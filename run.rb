# frozen_string_literal: true

require_relative('lib/parser')

filepath = 'file/input/webserver.log'
parser = Parser.new
parser.desc_most_page_views(filepath)
parser.desc_most_unique_page_views(filepath)
parser.print_most_page_views
parser.print_most_unique_page_views
