class UserRepresenter

    def initialize(user, image_url)
      @user = user
      @image_url = image_url
    end

    def as_json
        {
          id: user.id,
          name: user.name,
          email: user.email,
          image: @image_url
        }
    end

    private
    attr_reader :user
end
