import ephem
import math


def _create_observer(date: bytes) -> ephem.Observer:
    """Creates Ephem observer instance based on specified date, latitude, and longitude.

    Args:
        date (str): 'yyyy/mm/dd' formatted date string.

    Returns:
        ephem.Observer: Ephem observer instance.
    """
    observer = ephem.Observer()
    observer.date = date.decode("utf-8")

    return observer


def calculate_ecliptic_longitude_difference(date: bytes) -> int:
    """Calculates the ecliptic longitude difference between the sun and the moon at a given date and time and returns the angle (integer value).

    Args:
        date (str): 'yyyy/mm/dd' formatted date string.

    Returns:
        int: the ecliptic longitude difference between the sun and the moon (in the range of 0 to 360 degrees).
    """
    observer = _create_observer(date)

    sun, moon = ephem.Sun(observer), ephem.Moon(observer)
    diff = (moon.hlon - sun.hlon) % (2 * math.pi)
    diff_degree = math.degrees(diff)

    return round(diff_degree)
