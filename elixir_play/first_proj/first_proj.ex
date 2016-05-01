defmodule FirstProj do
  use Application

  def start(_type, _args) do
    FirstProj.Supervisor.start_link()
  end

  def main(args) do
    args |> parse_args |> process |> print_list
  end

  defp parse_args(args) do
    parse = OptionParser.parse(args,
      switches: [help: :boolean, list: :boolean])

    case parse do
      { [help: true], _, _ } -> :help
      { [list: true], _, _ } -> :list 
                          _  -> :help
    end
  end

  def process(:help) do
    IO.puts "Give List argument"
  end

  def process(:list) do
    {status, data} = File.read "todo.txt"
    {status, decoded} = Poison.decode(data)
    number_of_tasks = Map.keys(decoded) |> length
    {decoded, number_of_tasks}
  end

  def print_list({decoded, n}) when n <= 1 do
    IO.puts "#{decoded[Integer.to_string(n)]["task"]}"
  end

  def print_list({decoded, n}) do
    IO.puts "#{decoded[Integer.to_string(n)]["task"]}"
    print_list({decoded, n - 1})
  end

end
