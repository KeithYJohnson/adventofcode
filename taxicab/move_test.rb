require './move'

describe Move do
  let(:mover) { described_class.new(" R2, R2 ") }

  describe "#perform" do
    it 'can execute multiple instructions' do
      mover.perform
      expect(mover.x).to eq(2)
      expect(mover.y).to eq(-2)
    end
  end

  describe "visiting a location twice" do
    let(:mover) { described_class.new("R8, R4, R4, R8") }

    it 'correctly identifies the first one' do
      mover.perform
      twice_visited = mover.here_befores.first
      expect(twice_visited[0]).to eq([4,0])
      expect(twice_visited[1]).to eq(4)
    end
  end

  describe "#move" do
    it 'does stuff' do
      mover.move("R5")
      expect(mover.current_direction).to eq(1)
      expect(mover.x).to eq(5)
      expect(mover.y).to eq(0)
    end
  end

  describe "#rotate" do
    context 'rotating right' do
      it 'increments current direction' do
        mover.rotate("R")
        expect(mover.current_direction).to eq(1)
      end


      it "'increments' the current direction back to zero if at 3" do
        mover.current_direction = 3
        mover.rotate("R")
        expect(mover.current_direction).to eq(0)
      end
    end

    context 'rotating left' do
      it 'decrements to three if set to zero' do
        mover.rotate("L")
        expect(mover.current_direction).to eq(3)
      end

      it "'increments' the current direction back to zero if at 3" do
        mover.current_direction = 3
        mover.rotate("L")
        expect(mover.current_direction).to eq(2)
      end
    end
  end

  describe "#advance" do
    let(:magnitude) { 3 }
    let!(:old_x)     { mover.x }
    let!(:old_y)     { mover.y }

    context "pointing north" do
      it 'increases the y coordinate' do
        mover.current_direction = 0
        mover.advance(magnitude)
        expect(mover.y).to eq(old_y + magnitude)
        expect(mover.x).to eq(old_x)
      end
    end

    context "pointing east" do
      it 'increases the x coordinate' do
        mover.current_direction = 1
        mover.advance(magnitude)
        expect(mover.x).to eq(old_x + magnitude)
        expect(mover.y).to eq(old_y)
      end
    end

    context "pointing south" do
      it 'decreases the y coordinate' do
        mover.current_direction = 2
        mover.advance(magnitude)
        expect(mover.y).to eq(old_y - magnitude)
        expect(mover.x).to eq(old_x)
      end
    end

    context "pointing west" do
      it 'decreases the x coordinate' do
        mover.current_direction = 3
        mover.advance(magnitude)
        expect(mover.x).to eq(old_x - magnitude)
        expect(mover.y).to eq(old_y)
      end
    end
  end

  describe "#track_position" do
    let(:x) { 3 }
    let(:y) { 0 }
    let!(:old_num_positions) { mover.positions.length }
    before { mover.x = x; mover.y = y }

    it 'the ending coordinates will be the last element in the positions array' do
      mover.track_position
      expect(mover.positions.last[0]).to eq(x)
      expect(mover.positions.last[1]).to eq(y)
    end

    it 'appends each step of the journey into the positions array' do
      mover.track_position
      expect(mover.positions).to eq([[0,0], [1,0], [2,0], [3,0]])
    end

    context "change in y" do
      let(:x) { 0 }
      let(:y) { 3 }
      let!(:old_num_positions) { mover.positions.length }
      before { mover.x = x; mover.y = y }

      it 'the ending coordinates will be the last element in the positions array' do
        mover.track_position
        expect(mover.positions.last[0]).to eq(x)
        expect(mover.positions.last[1]).to eq(y)
      end

      it 'appends each step of the journey into the positions array' do
        mover.track_position
        expect(mover.positions).to eq([[0,0], [0,1], [0,2], [0,3]])
      end
    end
  end

  describe "#was_i_here_before?" do
    context 'mover visits a position twice' do
      subject { described_class.new("R1,L0,L1") }
      before { subject.perform }
      it { is_expected.to be_was_i_here_before }
    end

    context 'mover doesnt visit a postion twice' do
      subject { described_class.new("R1,L0") }
      before { subject.perform }
      it { is_expected.to_not be_was_i_here_before }
    end
  end
end
