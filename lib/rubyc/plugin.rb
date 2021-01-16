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
    def lint
      broken_files = []

      changed_files.each do |file|
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

    def changed_files
      (git.modified_files + git.added_files)
    end
  end
end
