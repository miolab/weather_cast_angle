const changeDateBy = (days: number): string => {
  const baseDateString = document.querySelector(".date")?.dataset.date;

  const dateParts = baseDateString.split("-").map(Number);
  const adjustedDate = new Date(
    dateParts[0],
    dateParts[1] - 1,
    dateParts[2] + days
  );
  const year = adjustedDate.getFullYear();
  const month = (adjustedDate.getMonth() + 1).toString().padStart(2, "0");
  const day = adjustedDate.getDate().toString().padStart(2, "0");

  return `${year}-${month}-${day}`;
};
