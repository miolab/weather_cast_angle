defmodule WeatherCastAngleWeb.SvgIcons do
  use WeatherCastAngleWeb, :html

  @doc """
  SVG icon: sunrise
  """
  @spec sunrise_icon(map()) :: Phoenix.LiveView.Rendered.t()
  def sunrise_icon(assigns),
    do: ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 -960 960 960"
      fill="#EA3323"
      aria-label="sunrise"
    >
      <path d="M440-760v-160h80v160h-80Zm266 110-55-55 112-115 56 57-113 113Zm54 210v-80h160v80H760ZM440-40v-160h80v160h-80ZM254-652 140-763l57-56 113 113-56 54Zm508 512L651-255l54-54 114 110-57 59ZM40-440v-80h160v80H40Zm157 300-56-57 112-112 29 27 29 28-114 114Zm283-100q-100 0-170-70t-70-170q0-100 70-170t170-70q100 0 170 70t70 170q0 100-70 170t-170 70Zm0-80q66 0 113-47t47-113q0-66-47-113t-113-47q-66 0-113 47t-47 113q0 66 47 113t113 47Zm0-160Z" />
    </svg>
    """

  @doc """
  SVG icon: sunset
  """
  @spec sunset_icon(map()) :: Phoenix.LiveView.Rendered.t()
  def sunset_icon(assigns),
    do: ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 -960 960 960"
      fill="#EAC452"
      aria-label="sunset"
    >
      <path d="M504-425Zm20 385H420l20-12.5q20-12.5 43.5-28t43.5-28l20-12.5q81-6 149.5-49T805-285q-86-8-163-43.5T504-425q-61-61-97-138t-43-163q-77 43-120.5 118.5T200-444v12l-12 5.5q-12 5.5-26.5 11.5T135-403.5l-12 5.5q-2-11-2.5-23t-.5-23q0-146 93-257.5T450-840q-18 99 11 193.5T561-481q71 71 165.5 100T920-370q-26 144-138 237T524-40Zm-284-80h180q25 0 42.5-17.5T480-180q0-25-17-42.5T422-240h-52l-20-48q-14-33-44-52.5T240-360q-50 0-85 34.5T120-240q0 50 35 85t85 35Zm0 80q-83 0-141.5-58.5T40-240q0-83 58.5-141.5T240-440q60 0 109.5 32.5T423-320q57 2 97 42.5t40 97.5q0 58-41 99t-99 41H240Z" />
    </svg>
    """

  @doc """
  SVG icon: humidity
  """
  @spec humidity_icon(map()) :: Phoenix.LiveView.Rendered.t()
  def humidity_icon(assigns),
    do: ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 -960 960 960"
      fill="#634FA2"
      aria-label="humidity"
    >
      <path d="M580-240q25 0 42.5-17.5T640-300q0-25-17.5-42.5T580-360q-25 0-42.5 17.5T520-300q0 25 17.5 42.5T580-240Zm-202-2 260-260-56-56-260 260 56 56Zm2-198q25 0 42.5-17.5T440-500q0-25-17.5-42.5T380-560q-25 0-42.5 17.5T320-500q0 25 17.5 42.5T380-440ZM480-80q-137 0-228.5-94T160-408q0-100 79.5-217.5T480-880q161 137 240.5 254.5T800-408q0 140-91.5 234T480-80Zm0-80q104 0 172-70.5T720-408q0-73-60.5-165T480-774Q361-665 300.5-573T240-408q0 107 68 177.5T480-160Zm0-320Z" />
    </svg>
    """

  @doc """
  SVG icon: wind speed
  """
  @spec wind_speed_icon(map()) :: Phoenix.LiveView.Rendered.t()
  def wind_speed_icon(assigns),
    do: ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 -960 960 960"
      fill="#94a3b8"
      aria-label="wind speed"
    >
      <path d="M460-160q-50 0-85-35t-35-85h80q0 17 11.5 28.5T460-240q17 0 28.5-11.5T500-280q0-17-11.5-28.5T460-320H80v-80h380q50 0 85 35t35 85q0 50-35 85t-85 35ZM80-560v-80h540q26 0 43-17t17-43q0-26-17-43t-43-17q-26 0-43 17t-17 43h-80q0-59 40.5-99.5T620-840q59 0 99.5 40.5T760-700q0 59-40.5 99.5T620-560H80Zm660 320v-80q26 0 43-17t17-43q0-26-17-43t-43-17H80v-80h660q59 0 99.5 40.5T880-380q0 59-40.5 99.5T740-240Z" />
    </svg>
    """

  @doc """
  SVG icon: wind direction

  - Default icon direction is __southwest__ .
  - For the argument, the value obtained from `WeatherDataProcessor.wind_direction_flag` is assumed to be used.
  """
  @spec wind_direction_icon(%{direction: atom() | nil}) :: Phoenix.LiveView.Rendered.t()
  def wind_direction_icon(%{direction: nil} = assigns),
    do: ~H"""
    <span>-</span>
    """

  def wind_direction_icon(%{direction: direction_flag} = assigns) do
    aria_label_text = "wind direction #{to_string(direction_flag)}"
    rotate_class = "origin-center #{_wind_direction_rotate_class(direction_flag)}"

    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 14 14"
      fill="#94a3b8"
      aria-label={aria_label_text}
      class={rotate_class}
    >
      <path d="M13.9605 0.69482c0.0793 -0.187513 0.037 -0.404403 -0.1069 -0.548373 -0.144 -0.14397052 -0.3609 -0.1862631 -0.5484 -0.1069306L0.30518 5.53952c-0.179689 0.07602 -0.29874413 0.24962 -0.304928737 0.44463 -0.006184603 0.19501 0.101630737 0.37581 0.276141737 0.46306L5.12732 8.87268l2.42547 4.85092c0.08725 0.1745 0.26805 0.2823 0.46306 0.2761 0.19501 -0.0061 0.36861 -0.1252 0.44463 -0.3049L13.9605 0.69482Z">
      </path>
    </svg>
    """
  end

  @spec _wind_direction_rotate_class(atom()) :: String.t()
  defp _wind_direction_rotate_class(direction_flag) when direction_flag == :north,
    do: "rotate-[135deg]"

  defp _wind_direction_rotate_class(direction_flag) when direction_flag == :northeast,
    do: "rotate-[180deg]"

  defp _wind_direction_rotate_class(direction_flag) when direction_flag == :east,
    do: "rotate-[225deg]"

  defp _wind_direction_rotate_class(direction_flag) when direction_flag == :southeast,
    do: "rotate-[270deg]"

  defp _wind_direction_rotate_class(direction_flag) when direction_flag == :south,
    do: "rotate-[315deg]"

  defp _wind_direction_rotate_class(direction_flag) when direction_flag == :southwest,
    do: "rotate-0"

  defp _wind_direction_rotate_class(direction_flag) when direction_flag == :west,
    do: "rotate-[45deg]"

  defp _wind_direction_rotate_class(direction_flag) when direction_flag == :northwest,
    do: "rotate-[90deg]"

  defp _wind_direction_rotate_class(_), do: ""
end
