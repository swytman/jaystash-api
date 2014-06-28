class Stash < ActiveRecord::Base
  require 'digest/sha2'
  belongs_to :contentable, polymorphic: true

  def gen_digest tags
    str = tags.split.sort.join('ololo')
    self.digest = Digest::SHA2.hexdigest(str)
  end

end