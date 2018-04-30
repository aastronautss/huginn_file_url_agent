# frozen_string_literal: true

require 'open-uri'

module Agents
  ##
  # = Huginn File URL agent
  #
  class FileUrlAgent < Agent
    include FileHandling

    no_bulk_receive!
    emits_file_pointer!
    can_dry_run!

    default_schedule 'every_2m'

    description <<-MD
      The File URL agent takes a url and emits an event with a `file_pointer`. Optionally, you can merge
    MD

    def default_options
      {
        url: '{{ url }}',
        merge: 'true'
      }
    end

    def validate_options
      errors.add(:base, "The 'url' option is required") unless options['url'].present?
      errors.add(:base, "The 'merge' option must be 'true' or 'false'") unless %w[true false].include?(options['merge'])
    end

    def working?
      received_event_without_error?
    end

    def receive(incoming_events)
      incoming_events.each { |event| receive_event event }
    end

    def get_io(file)
      Down.open(file)
    end

    private

    def receive_event(event)
      interpolate_with(event) do
        existing_data = merge? ? event.payload : {}
        data = get_file_pointer(interpolated['url']).merge(existing_data)

        create_event payload: data
      end
    end

    def merge?
      boolify(interpolated['merge'])
    end
  end
end
