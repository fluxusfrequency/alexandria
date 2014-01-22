class UserRepository < UserModel
  self.table_name = "user"
  set_fixture_class user_repository: User
  fixtures :users
end