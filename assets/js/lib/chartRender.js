import Chart from "chart.js/auto";

export function renderChart() {
  const chartArea = document.querySelector(".chart-area");
  const tideLevels = JSON.parse(chartArea.dataset.tideLevels);

  const date = document.querySelector(".date").dataset.date;

  new Chart(chartArea, {
    type: "bar",
    data: {
      labels: Array.from({ length: 24 }, (_, i) => i.toString()),
      datasets: [
        {
          label: `${date} Tide Levels`,
          data: tideLevels,
          borderWidth: 1,
        },
      ],
    },
    options: {
      scales: {
        y: {
          beginAtZero: true,
        },
      },
    },
  });
}
