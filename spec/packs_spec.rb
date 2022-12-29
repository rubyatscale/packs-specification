# frozen_string_literal: true

RSpec.describe Packs do
  describe '.all' do
    context 'in app with a simple package' do
      before do
        write_file('packs/my_pack/package.yml')
      end

      it { expect(Packs.all.count).to eq 1 }
    end

    context 'in an app with nested packs' do
      before do
        write_file('packs/my_pack/package.yml')
        write_file('packs/my_pack/subpack/package.yml')
      end

      it { expect(Packs.all.count).to eq 2 }
    end

    context 'in an app with a differently configured root' do
      before do
        write_file('packs/my_pack/package.yml')
        write_file('components/my_pack/package.yml')
        write_file('packs.yml', <<~YML)
        pack_paths:
          - packs/*
          - components/*
        YML
      end

      it { expect(Packs.all.count).to eq 2 }
    end
  end

  describe '.find' do
    context 'in app with a simple package' do
      before do
        write_file('packs/my_pack/package.yml')
      end

      it { expect(Packs.find('packs/my_pack').name).to eq 'packs/my_pack' }
    end

    context 'in an app with nested packs' do
      before do
        write_file('packs/my_pack/package.yml')
        write_file('packs/my_pack/subpack/package.yml')
      end

      it { expect(Packs.find('packs/my_pack').name).to eq 'packs/my_pack' }
      it { expect(Packs.find('packs/my_pack/subpack').name).to eq 'packs/my_pack/subpack' }
    end

    context 'in an app with a differently configured root' do
      before do
        write_file('packs/my_pack/package.yml')
        write_file('components/my_pack/package.yml')
        write_file('packs.yml', <<~YML)
        pack_paths:
          - packs/*
          - components/*
        YML
      end

      it { expect(Packs.find('packs/my_pack').name).to eq 'packs/my_pack' }
      it { expect(Packs.find('components/my_pack').name).to eq 'components/my_pack' }
    end
  end

  describe '.for_file' do
    before do
      write_file('packs/package_1/package.yml')
      write_file('packs/package_1_new/package.yml')
    end

    context 'given a filepath in pack_1' do
      let(:filepath) { 'packs/package_1/path/to/file.rb' }
      it { expect(Packs.for_file(filepath).name).to eq 'packs/package_1' }
    end

    context 'given a file path in pack_1_new' do
      let(:filepath) { 'packs/package_1_new/path/to/file.rb' }
      it { expect(Packs.for_file(filepath).name).to eq 'packs/package_1_new' }
    end

    context 'given a file path that is exactly the root of a pack' do
      let(:filepath) { 'packs/package_1' }
      it { expect(Packs.for_file(filepath).name).to eq 'packs/package_1' }
    end

    context 'given a file path not in a pack' do
      let(:filepath) { 'path/to/file.rb' }
      it { expect(Packs.for_file(filepath)).to eq nil }
    end

    context 'in an app with nested packs' do
      before do
        write_file('packs/my_pack/package.yml')
        write_file('packs/my_pack/file.rb')
        write_file('packs/my_pack/subpack/package.yml')
        write_file('packs/my_pack/subpack/file.rb')
      end

      it 'distinguishes between files in nested packs and parent packs' do
        expect(Packs.for_file('packs/my_pack/subpack/file.rb').name).to eq 'packs/my_pack/subpack'
        expect(Packs.for_file('packs/my_pack/file.rb').name).to eq 'packs/my_pack'
      end
    end
  end
end
