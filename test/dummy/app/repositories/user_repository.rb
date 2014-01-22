class UserRepository < ActiveRecord::Base
  def base_model
    class User < ActiveRecord::Base

  end
end

