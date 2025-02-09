import dayjs from "dayjs";
import "dayjs/locale/ja";

dayjs.locale("ja");

/**
 * Format the date into Japanese month-day + day-of-week format.
 *
 * @param dateString - “YYYYY-MM-DD” formatted Date string.
 * @returns {string} - "1月23日(土)" formatted Date string in Japanese.
 */
const formatDate = (dateString: string): string => {
  const date = dayjs(dateString);
  return date.format("M月D日(ddd)");
};

/**
 * Finds all elements with the class `.js-format-japanese-date`,
 * and formats their `data-date` attribute into Japanese date format.
 */
export const autoFormatJapaneseDates = (): void => {
  document
    .querySelectorAll<HTMLElement>(".js-format-japanese-date")
    .forEach((element) => {
      const rawDate = element.getAttribute("data-date");
      if (rawDate) {
        element.textContent = formatDate(rawDate);
      }
    });
};
