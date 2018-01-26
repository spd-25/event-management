class Upload < ApplicationRecord
  belongs_to :user

  has_attached_file :upload_file
  do_not_validate_attachment_file_type :upload_file
end
