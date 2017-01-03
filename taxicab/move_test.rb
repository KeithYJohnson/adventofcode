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
    let(:y) { 4 }

    it 'the current x,y coordinates to the positions array' do
      mover.x = x
      mover.y = y
      mover.track_position
      expect(mover.positions.last[0]).to eq(x)
      expect(mover.positions.last[1]).to eq(y)
    end
  end

  describe "was_i_here_before?" do
    before { mover.move("R4") }
    
    it 'returns true if Ive been at the current position before' do
      mover.move("R0") # Only rotates, doesnt move
      expect(mover).to be_was_i_here_before
    end

    it 'returns false if its a new position' do
      mover.move("R4")
      expect(mover).to_not be_was_i_here_before
    end
  end
end
