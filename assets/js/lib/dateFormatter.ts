import dayjs from "dayjs";
import "dayjs/locale/ja";

dayjs.locale("ja");

/**
 * Format the date into Japanese month-day + day-of-week format.
 *
 * @param dateString - “YYYYY-MM-DD” formatted Date string.
 * @returns {string} - "1月23日(土)" formatted Date string in Japanese.
 */
export function formatDate(dateString: string): string {
  const date = dayjs(dateString);
  return date.format("M月D日(ddd)");
}
