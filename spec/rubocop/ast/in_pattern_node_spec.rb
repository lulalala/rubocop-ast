# frozen_string_literal: true

RSpec.describe RuboCop::AST::InPatternNode do
  context 'when using Ruby 2.7 or newer', :ruby27 do
    let(:in_pattern_node) { parse_source(source).ast.children[1] }

    describe '.new' do
      let(:source) do
        ['case condition',
         'in [42] then foo',
         'end'].join("\n")
      end

      it { expect(in_pattern_node).to be_a(described_class) }
    end

    describe '#then?' do
      context 'with a then keyword' do
        let(:source) do
          ['case condition',
           'in [42] then foo',
           'end'].join("\n")
        end

        it { expect(in_pattern_node).to be_then }
      end

      context 'without a then keyword' do
        let(:source) do
          ['case condition',
           'in [42]',
           '  foo',
           'end'].join("\n")
        end

        it { expect(in_pattern_node).not_to be_then }
      end
    end

    describe '#body' do
      context 'with a then keyword' do
        let(:source) do
          ['case condition',
           'in [42] then :foo',
           'end'].join("\n")
        end

        it { expect(in_pattern_node.body).to be_sym_type }
      end

      context 'without a then keyword' do
        let(:source) do
          ['case condition',
           'in [42]',
           '  [:foo, :bar]',
           'end'].join("\n")
        end

        it { expect(in_pattern_node.body).to be_array_type }
      end
    end

    describe '#branch_index' do
      let(:source) do
        ['case condition',
         'in [42] then 1',
         'in [43] then 2',
         'in [44] then 3',
         'end'].join("\n")
      end

      let(:in_patterns) { parse_source(source).ast.children[1...-1] }

      it { expect(in_patterns[0].branch_index).to eq(0) }
      it { expect(in_patterns[1].branch_index).to eq(1) }
      it { expect(in_patterns[2].branch_index).to eq(2) }
    end
  end
end
