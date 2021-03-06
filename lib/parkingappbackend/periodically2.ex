defmodule Parkingappbackend.Periodically2 do
  use GenServer

  alias Parkingappbackend.Sales


  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work() # Schedule work to be performed at some point

    {:ok, state}
  end

  def handle_info(:work, state) do
    ###############################
    # Do the work you desire here #
    ###############################

    bookings = Sales.list_bookings_active()
    bookings = Enum.filter( bookings, fn(%{end_time: end_time}) -> Timex.diff(Timex.parse!(end_time , "{RFC3339}") ,Timex.now , :minutes) <= 2 end)
    bookings = Enum.filter( bookings, fn(%{calc_criteria: calc_criteria}) -> calc_criteria == 1 end)
    Parkingappbackend.Space.release_parkings(bookings)
    Parkingappbackend.Sales.finish_bookings(bookings)

    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 30 * 1000) #Every 1min
  end
end
