class String
  def to_dpkg_field
    self.tr('_', '-').split('-').map(&:capitalize).join('-')
  end

  def to_dpkg_field!
    str = self.dup
    self.replace(str.to_dpkg_field)
  end

  def from_dpkg_field
    self.tr('-', '_').split('_').map(&:downcase).join('_')
  end

  def from_dpkg_field!
    str = self.dup
    self.replace(str.from_dpkg_field)
  end
end
