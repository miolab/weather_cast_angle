import Chart from "chart.js/auto";

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
