require 'spec_helper'

module Adept
  describe Package do

    let(:file) { 'foo_1.0.0-1~lucid_amd64.deb' }
    let(:package) { build(:package) }

    before do
      package.stub(:run).with("-f #{file} Version").and_return("1.0.0-1")
      package.stub(:run).with("-f #{file} Architecture").and_return("amd64")
      package.stub(:run).with("-f #{file} Source").and_return("")
    end

    describe '#read_field' do
      context 'when the file exists' do
        it 'returns a field from a package with a string' do
          package.read_field('version').should == '1.0.0-1'
        end

        it 'returns a field from a package with a symbol' do
          package.read_field(:version).should == '1.0.0-1'
        end
      end

      #TODO: fix this spec
      context 'when the file does not exist' do
        it 'raises Errno::ENOENT if the file does not exist'
      end
    end

    context 'dynamic getters' do
      before do
        package.stub(:run).with("-f #{file} Version").and_return("1.0.0-1")
        package.stub(:run).with("-f #{file} Architecture").and_return("amd64")
        package.stub(:run).with("-f #{file} Source").and_return("")
      end

      subject { package }

      its(:version) { should eql('1.0.0-1') }
      its(:architecture) { should eql('amd64') }
      its(:source) { should be_nil }

      it 'raises NoMethodError if an invalid field is requested' do
        expect { package.blah }.to raise_error(NoMethodError)
      end
    end

    describe '#to_path' do
      context 'regular package with no source' do
        let(:package) { build(:package) }
        let(:file) { package.file }

        before do
          package.stub(:package).and_return("foo")
          package.stub(:source).and_return(nil)
        end

        it 'returns the path to the package' do
          package.to_path.should == "pool/main/f/foo/#{package.file}"
        end
      end

      context 'regular package with source' do
        let(:package) { build(:package) }
        let(:file) { package.file }

        before do
          package.stub(:package).and_return("foo")
          package.stub(:source).and_return("foo-1.0")
        end

        it 'returns the path to the package' do
          package.to_path.should == "pool/main/f/foo-1.0/#{package.file}"
        end
      end

      context 'library package without source' do
        let(:package) { build(:package, :file => 'libfoo_1.0.0-1_amd64.deb') }
        let(:file) { package.file }

        before do
          package.stub(:package).and_return("libfoo")
          package.stub(:source).and_return(nil)
        end

        it 'returns the path to the package' do
          package.to_path.should == "pool/main/libf/libfoo/#{package.file}"
        end
      end
    end
  end
end
