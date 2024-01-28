const changeDateBy = (days: number): string => {
  const baseDateString = document.querySelector(".js-date")?.dataset.date;

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

const setInputAdjustedDateAndSubmit = (days: number): void => {
  const dateInput = document.querySelector(
    ".js-input-date"
  ) as HTMLInputElement;

  dateInput.value = changeDateBy(days);
  dateInput.form?.submit();
};

export function changeDateAndSubmit(): void {
  document
    .querySelector(".js-proceed-next-day")
    ?.addEventListener("click", () => setInputAdjustedDateAndSubmit(1));

  document
    .querySelector(".js-proceed-before-day")
    ?.addEventListener("click", () => setInputAdjustedDateAndSubmit(-1));
}
