import ephem


def _create_observer(date: bytes, latitude: float, longitude: float) -> ephem.Observer:
    """Creates Ephem observer instance based on specified date, latitude, and longitude.

    Args:
        date (str): 'yyyy/mm/dd' formatted date string.
        latitude (float): target location's latitude.
        longitude (float): target location's longitude.

    Returns:
        ephem.Observer: Ephem observer instance.
    """
    observer = ephem.Observer()
    observer.date = date.decode("utf-8")
    observer.lat, observer.lon = str(latitude), str(longitude)

    return observer


def get_moon_phase(date: bytes, latitude: float, longitude: float) -> float:
    """Calculates the moon phase.

    Args:
        date (str): 'yyyy/mm/dd' formatted date string.
        latitude (float): target location's latitude.
        longitude (float): target location's longitude.

    Returns:
        float: moon phase calculated by percent of surface illuminated.
    """
    observer = _create_observer(date, latitude, longitude)
    moon = ephem.Moon(observer)

    return moon.phase / 100


# TODO: デバッグ用。あとで消す
# python lib/python_manager/py_modules/moon_phase_calculator.py
if __name__ == "__main__":
    print(get_moon_phase(b"2024-01-21", 33.9484466691993, 130.96263530779785))
