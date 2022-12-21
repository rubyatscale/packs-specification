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
end
