class Wor::Version < PaperTrail::Version
  self.table_name = :wor_versions

  # def user
  #   User.find whodunnit.to_i if !whodunnit.blank?
  # end
end
