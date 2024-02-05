import Chart from "chart.js/auto";

interface ForecastData {
  weather_description: string;
  weather_main: string;
  weather_icon_uri: string;
  probability_of_precipitation: number;
  wind_speed: number;
  wind_deg: number;
  main_temp: number;
  main_humidity: number;
}

/**
 * Retrieves the weather forecast data from the DOM and returns it as a sorted array.
 *
 * - Each item in the array is an object with a single key representing the time slot (e.g., "00", "03", "06", etc.) and its corresponding weather data as the value.
 * - If it is an empty array, the function will return an empty array.
 *
 * @returns {Array} An array of weather forecast data objects sorted by time slot keys, or an empty array if no data is found.
 */
const weatherForecastJson = (): { [key: string]: ForecastData }[] | [] => {
  const forecasts = document.querySelector(".js-weather-forecast")?.dataset
    .weatherForecast;
  if (forecasts == "[]") return [];

  const forecastJson = JSON.parse(forecasts);

  const sortedForecastJson = forecastJson.sort((a, b) => {
    const keyA = parseInt(Object.keys(a)[0], 10);
    const keyB = parseInt(Object.keys(b)[0], 10);
    return keyA - keyB;
  });
  return sortedForecastJson;
};

/**
 * Renders a chart displaying tide levels for a specific location and date.
 *
 * - The chart displays tide levels for each hour over a 24-hour period.
 * - The current hour is highlighted with a different color and an increased point radius.
 */
export function renderChart(): void {
  const chartArea = document.querySelector(".chart-area") as HTMLCanvasElement;
  const tideLevels: number[] = JSON.parse(chartArea.dataset.tideLevels);

  const date: string = document.querySelector(".js-date")?.dataset.date;
  const currentHour: number = new Date().getHours();

  const backgroundColors: string[] = tideLevels.map((_, index) =>
    index === currentHour ? "rgba(255, 0, 54, 0.8)" : "rgba(54, 162, 235, 0.6)"
  );
  const pointRadius: number[] = tideLevels.map((_, index) =>
    index === currentHour ? 5 : 0
  );

  const locationCode: string =
    document.querySelector(".location-code")?.dataset.locationCode;

  new Chart(chartArea, {
    type: "bar",
    data: {
      labels: Array.from({ length: 24 }, (_, i) => i.toString()),
      datasets: [
        {
          label: `${date} ${locationCode} Tide Levels`,
          data: tideLevels,
          backgroundColor: backgroundColors,
          borderWidth: 1,
        },
        {
          // FIXME: label は非表示にする
          label: "",
          data: tideLevels,
          type: "line",
          borderColor: "transparent",
          pointBackgroundColor: "magenta",
          pointRadius: pointRadius,
        },
      ],
    },
    options: {
      scales: {
        y: {
          max: 240,
          min: -80,
        },
      },
    },
  });
}
