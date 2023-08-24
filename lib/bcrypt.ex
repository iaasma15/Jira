defmodule Bcrypt do
  def hash_pwd_salt(pass) do
    Base.encode64(pass)
  end

  def verify_pass(pass, hash) do
    Base.decode64!(hash) == pass
  rescue
    ArgumentError ->
      nil
  end
end
