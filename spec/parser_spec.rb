# frozen_string_literal: true

require 'parser'
require './lib/customized_error'

RSpec.describe Parser do
  subject { described_class.new }

  filepath = 'spec/file/input/test.log'
  url1 = '/test_page/1'
  url2 = '/test_page2'
  url3 = '/test_page3'
  url4 = '/test_page4'
  ip1 = '111.111.111.111'
  ip2 = '222.222.222.222'
  ip3 = '333.333.333.333'

  describe '#read_file' do
    it 'should receive an error that file does not exist' do
      allow(File).to receive(:file?).and_return(false)
      expect { subject.read_file(filepath) }.to raise_error(CustomizedError::FileDoesNotExistError)
    end

    it 'should receive an error that file is empty' do
      allow(File).to receive(:open).with(filepath, 'r').and_return({})
      expect { subject.read_file(filepath) }.to raise_error(CustomizedError::FileIsEmptyError)
    end

    it 'should get contents' do
      content = "#{url1} #{ip1}"
      allow(File).to receive(:open).with(filepath, 'r').and_return(content)
      expect(subject.read_file(filepath)).to eq(url1 => [ip1])
    end
  end

  describe '#desc_most_page_views' do
    it 'should sort descending order by most page views' do
      content =
        "#{url1} #{ip1}\n#{url1} #{ip2}\n
         #{url2} #{ip2}\n
         #{url3} #{ip3}\n
         #{url4} #{ip1}\n#{url4} #{ip2}\n#{url4} #{ip3}\n#{url4} #{ip1}"

      allow(File).to receive(:open).with(filepath, 'r').and_yield(StringIO.new(content))
      expect(subject.desc_most_page_views(filepath)).to eq(
        [
          [url4, [ip1, ip1, ip2, ip3]],
          [url1, [ip1, ip2]],
          [url2, [ip2]],
          [url3, [ip3]]
        ]
      )
    end
  end

  describe '#desc_most_unique_page_views' do
    it 'should sort descending order most unique page views' do
      content =
        "#{url1} #{ip1}\n#{url1} #{ip1}\n
         #{url2} #{ip1}\n#{url2} #{ip2}\n
         #{url3} #{ip3}\n
         #{url4} #{ip1}\n#{url4} #{ip2}\n#{url4} #{ip3}"

      allow(File).to receive(:open).with(filepath, 'r').and_yield(StringIO.new(content))
      expect(subject.desc_most_unique_page_views(filepath)).to eq(
        [
          [url4, [ip1, ip2, ip3]],
          [url2, [ip1, ip2]],
          [url1, [ip1]],
          [url3, [ip3]]
        ]
      )
    end
  end

  describe '#print_most_page_views' do
    it 'should receive empty' do
      expect(subject.print_most_page_views).to eq.empty
    end

    it 'should print most page views' do
      content =
        "#{url1} #{ip1}\n#{url1} #{ip2}\n
         #{url2} #{ip2}\n
         #{url3} #{ip3}\n
         #{url4} #{ip1}\n#{url4} #{ip2}\n#{url4} #{ip3}\n#{url4} #{ip1}"

      allow(File).to receive(:open).with(filepath, 'r').and_yield(StringIO.new(content))
      subject.desc_most_page_views(filepath)

      expect(subject.print_most_page_views).to output(
        "List of webpages with most page views ordered from most pages views to less page views\n
        /test_page4 4 visits\n/test_page/1 2 visits\n/test_page2 1 visit\/test_page3 1 visit"
      )
    end
  end

  describe '#print_most_unique_page_views' do
    it 'should receive empty' do
      expect(subject.print_most_unique_page_views).to eq.empty
    end

    it 'should print most uniqe page views' do
      content =
        "#{url1} #{ip1}\n#{url1} #{ip1}\n
         #{url2} #{ip1}\n#{url2} #{ip2}\n
         #{url3} #{ip3}\n
         #{url4} #{ip1}\n#{url4} #{ip2}\n#{url4} #{ip3}"

      allow(File).to receive(:open).with(filepath, 'r').and_yield(StringIO.new(content))
      subject.desc_most_unique_page_views(filepath)

      expect(subject.print_most_unique_page_views).to output(
        "List of webpages with most unique page views ordered from most unique pages views to less unique page views\n
        /test_page4 3 visits\n/test_page2 2 visits\n/test_page/1 1 visit\/test_page3 1 visit"
      )
    end
  end
end
