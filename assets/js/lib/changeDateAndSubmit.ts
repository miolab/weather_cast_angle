/**
 * Adds the specified number of days to the date and returns the new date in `YYYY-MM-DD` format.
 *
 * @param {number} days Number of days to add. Negative values retrieve dates in the past, positive values retrieve dates in the future.
 * @returns {string} Returns the date after addition in `YYYYY-MM-DD` format.
 */
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

/**
 * Change the date by the specified number of days, set the value to the input element, and then submit the associated form.
 *
 * @param {number} days - Number of days to add.
 */
const setInputAdjustedDateAndSubmit = (days: number): void => {
  const dateInput = document.querySelector(
    ".js-input-date"
  ) as HTMLInputElement;

  dateInput.value = changeDateBy(days);
  dateInput.form?.submit();
};

/**
 * Sets up event listeners for buttons to proceed to an arbitrary date.
 * When these buttons are clicked, the date is adjusted, and the form is submitted.
 */
export function changeDateAndSubmit(): void {
  document
    .querySelector(".js-proceed-next-day")
    ?.addEventListener("click", () => setInputAdjustedDateAndSubmit(1));

  document
    .querySelector(".js-proceed-before-day")
    ?.addEventListener("click", () => setInputAdjustedDateAndSubmit(-1));
}
