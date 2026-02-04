# frozen_string_literal: true

RSpec.describe Packs::Pack do
  describe '.from' do
    context 'simple package' do
      before do
        write_file('packs/my_pack/package.yml')
      end

      let(:pack) { Packs::Pack.from(Pathname.pwd.join('packs/my_pack/package.yml')) }
      it { expect(pack.name).to eq 'packs/my_pack' }
      it { expect(pack.last_name).to eq 'my_pack' }
      it { expect(pack.yml).to eq Pathname.new('packs/my_pack/package.yml') }
      it { expect(pack.yml(relative: false)).to eq Pathname.pwd.join('packs/my_pack/package.yml') }
      it { expect(pack.relative_path).to eq Pathname.new('packs/my_pack') }
      it { expect(pack.raw_hash).to eq({}) }
    end

    context 'package with metadata and other properties' do
      before do
        write_file('packs/package_1/package.yml', <<~CONTENTS)
          enforce_dependencies: true
          enforce_privacy: true
          other_key: 'blah'
          metadata:
            string_key: this_is_a_string
            obviously_a_boolean_key: false
            not_obviously_a_boolean_key: no
            numeric_key: 123
        CONTENTS
      end

      let(:pack) { Packs::Pack.from(Pathname.pwd.join('packs/package_1/package.yml')) }

      it 'provides trivial accessors to other properties' do
        expect(pack.raw_hash['enforce_dependencies']).to eq true
        expect(pack.raw_hash['enforce_privacy']).to eq true
        expect(pack.raw_hash['other_key']).to eq 'blah'
        expect(pack.metadata['string_key']).to eq 'this_is_a_string'
        expect(pack.metadata['obviously_a_boolean_key']).to eq false
        expect(pack.metadata['not_obviously_a_boolean_key']).to eq false
        expect(pack.metadata['numeric_key']).to eq 123
      end
    end
  end

  describe 'lazy loading' do
    before do
      write_file('packs/my_pack/package.yml', <<~CONTENTS)
        enforce_privacy: true
        metadata:
          owner: MyTeam
      CONTENTS
    end

    let(:pack) { Packs::Pack.from(Pathname.pwd.join('packs/my_pack/package.yml')) }

    it 'does not load raw_hash until accessed' do
      expect(pack.instance_variable_get(:@raw_hash)).to be_nil
    end

    it 'loads raw_hash when accessed' do
      pack.raw_hash
      expect(pack.instance_variable_get(:@raw_hash)).to eq({ 'enforce_privacy' => true, 'metadata' => { 'owner' => 'MyTeam' } })
    end

    it 'loads raw_hash when metadata is accessed' do
      pack.metadata
      expect(pack.instance_variable_get(:@raw_hash)).not_to be_nil
    end
  end

  describe '#inspect' do
    before do
      write_file('packs/my_pack/package.yml', <<~CONTENTS)
        enforce_privacy: true
      CONTENTS
    end

    let(:pack) { Packs::Pack.from(Pathname.pwd.join('packs/my_pack/package.yml')) }

    it 'only includes @name in inspect output' do
      expect(pack.inspect).to match(/^#<Packs::Pack:0x[0-9a-f]+ @name="packs\/my_pack">$/)
    end

    it 'does not include other instance variables in inspect output' do
      expect(pack.inspect).not_to include('@path')
      expect(pack.inspect).not_to include('@relative_path')
      expect(pack.inspect).not_to include('@raw_hash')
    end
  end

  describe '#instance_variables_to_inspect', if: RUBY_VERSION >= '4' do
    before do
      write_file('packs/my_pack/package.yml')
    end

    let(:pack) { Packs::Pack.from(Pathname.pwd.join('packs/my_pack/package.yml')) }

    it 'is respected by Kernel#inspect' do
      expect(pack.inspect).to include('@name=')
      expect(pack.inspect).not_to include('@path=')
    end
  end

  describe '.is_gem?' do
    let(:subject) { Packs.find('packs/my_pack').is_gem? }

    context 'pack is not a gem' do
      before do
        write_file('packs/my_pack/package.yml')
      end

      it { is_expected.to eq false }
    end

    context 'pack is a gem' do
      before do
        write_file('packs/my_pack/package.yml')
        write_file('packs/my_pack/my_pack.gemspec')
      end

      it { is_expected.to eq true }
    end
  end
end
