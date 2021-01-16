module Danger
  # This is your plugin class. Any attributes or methods you expose here will
  # be available from within your Dangerfile.
  #
  # To be published on the Danger plugins site, you will need to have
  # the public interface documented. Danger uses [YARD](http://yardoc.org/)
  # for generating documentation from your plugin source, and you can verify
  # by running `danger plugins lint` or `bundle exec rake spec`.
  #
  # You should replace these comments with a public description of your library.
  #
  # @example Ensure people are well warned about merging on Mondays
  #
  #          my_plugin.warn_on_mondays
  #
  # @see  Stanislav/danger-rubyc
  # @tags monday, weekends, time, rattata
  #
  class DangerRubyc < Plugin
    # Runs Ruby files through Rubocop.
    #
    # @return  [void]
    #
    def lint
      broken_files = []

      fetch_files_to_lint.each do |file|
        next unless File.readable?(file)

        if file.end_with?('.rb') || file.eql?('Rakefile')
          broken_files << file unless system('ruby', '-c', file)
        end
      end

      if !broken_files.empty?
        fail("Ruby code is not valid (SyntaxError) in files:
          **#{broken_files.join('<br/>')}**
        ")
      end

    end

    private

    def offenses_message(offending_files, include_cop_names: false)
      require 'terminal-table'

      message = "### Ruby syntax problems\n\n"
      table = Terminal::Table.new(
        headings: %w(File Line Reason),
        style: { border_i: '|'},
        rows: offending_files.flat_map do |file|
          file['offenses'].map do |offense|
            offense_message = offense['message']
            offense_message = offense['cop_name'] + ': ' + offense_message if include_cop_names
            [file['path'], offense['location']['line'], offense_message]
          end
        end
      ).to_s
      message + table.split("\n")[1..-2].join("\n")
    end

    def fetch_files_to_lint
      binding.pry
      (git.modified_files + git.added_files)
    end
  end
end
