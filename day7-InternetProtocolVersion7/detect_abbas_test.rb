require './detect_abbas'

describe DetectAbbas do
  let(:action) { described_class.new('test_input.txt') }
  let(:supports_tls) { "abba[mnop]qrst" }
  let(:no_tls)  { "abcd[bddb]xyyx" }
  let(:two_brackets_no_tls) { "abcd[bdda]xyyx[bddb]" }

  describe "#supports_tls?" do
    context 'supports tls' do
      subject { action.supports_tls?(supports_tls) }
      it      { is_expected.to be_truthy }
    end

    context "doesnt support" do
      subject { action.supports_tls?(no_tls) }
      it      { is_expected.to be_falsey }
    end

    context "only one of many brackets has an abba" do
      subject { action.supports_tls?(two_brackets_no_tls) }
      it      { is_expected.to be_falsey }
    end
  end

  describe "#has_abba?" do
    context "has abba" do
      subject { action.has_abba?("abba") }
      it      { is_expected.to be_truthy }
    end

    context "no abba" do
      subject { action.has_abba?("creditswilldofine") }
      it      { is_expected.to be_falsey }
    end
  end
end
