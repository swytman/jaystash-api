class Message < ActiveRecord::Base
  has_one :stash, as: :contentable
end