class PostsDeletionJob
  include Sidekiq::Job

  def perform(*args)
    id = args.first
    Post.destroy(id)
    puts "Post with #{id} deleted"
  end
end
