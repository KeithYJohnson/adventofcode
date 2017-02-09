require './decompress'

describe Decompress do
  let(:action) { described_class.new('test_input.txt') }

  describe "#decompress_marker" do
    context '1x5' do #(1x5)BC
      subject { action.decompress_marker("1x5", "BC") }
      it { is_expected.to eq("BBBBBC") }
    end

    context do # (3x3)XYZ
      subject { action.decompress_marker("3x3", "XYZ") }
      it { is_expected.to eq("XYZXYZXYZ") }
    end

    context do # (2x2)BCD
      subject { action.decompress_marker("2x2", "BCD") }
      it { is_expected.to eq("BCBCD") }
    end
  end

  describe "#find_next_marker" do
    before { action.compressed = "A(2x2)BCD(2x2)EFG" }
    context do
      subject { action.find_next_marker }
      it      { is_expected.to eq("2x2") }
    end
  end
end
