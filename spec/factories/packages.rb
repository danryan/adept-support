
FactoryGirl.define do
  factory :package, :class => Adept::Package do
    file 'foo_1.0.0-1~lucid_amd64.deb'
    distro 'lucid'
    component 'main'
  end
end
