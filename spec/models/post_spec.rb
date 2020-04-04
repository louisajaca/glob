require 'minitest/autorun'
require_relative '../spec_helper_lite'
stub_module 'ActiveModel::Conversion'
stub_module 'ActiveModel::Naming'
require_relative '../../app/models/post'
require 'date'


describe Post do
  before do
    @it = Post.new
  end

  it "starts with blank attributes" do
    expect(@it.title).must_be_nil
    expect(@it.body).must_be_nil
  end

  it "supports reading and writing a title" do
    @it.title = "foo"
    expect(@it.title).must_equal "foo"
  end

  it "supports reading and writing a body" do
    @it.body = "foo"
    expect(@it.body).must_equal "foo"
  end

  it "supports reading and writing a blog reference" do
    blog = Object.new
    @it.blog = blog
    expect(@it.blog).must_equal blog
  end

  it "supports setting attributes in the initializer" do
    it = Post.new(title: "mytitle", body: "mybody")
    expect(it.title).must_equal "mytitle"
    expect(it.body).must_equal "mybody"
  end

  describe "#publish" do
    before do
      @blog = MiniTest::Mock.new
      @it.blog = @blog
    end

    after do
      @blog.verify
    end

    it "adds the post to the blog" do
      @blog.expect :add_entry, nil, [@it]
      @it.publish
    end
  end

  describe "#pubdate" do
    describe "before publishing" do
      it "is blank" do
        expect(@it.pubdate).must_be_nil
      end
    end

    describe "after publishing" do
      before do
        @clock = stub!
        @now = DateTime.parse("2011-09-11T02:56")
        stub(@clock).now() { @now }
        @it.blog = stub!
        @it.publish(@clock)
      end

      it "is a datetime" do
        expect(@it.pubdate.class).must_equal DateTime
      end

      it "is the current time" do
        expect(@it.pubdate).must_equal(@now)
      end
    end
  end
end