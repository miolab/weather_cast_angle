import Chart from "chart.js/auto";

export function renderChart() {
  const chartArea = document.querySelector(".chart-area");
  const tideLevels = JSON.parse(chartArea.dataset.tideLevels);

  const date = document.querySelector(".date").dataset.date;
  const currentHour = new Date().getHours();

  const backgroundColors = tideLevels.map((_, index) =>
    index === currentHour ? "rgba(255, 0, 54, 0.8)" : "rgba(54, 162, 235, 0.6)"
  );
  const pointRadius = tideLevels.map((_, index) =>
    index === currentHour ? 5 : 0
  );

  const locationCode =
    document.querySelector(".location-code").dataset.locationCode;

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
