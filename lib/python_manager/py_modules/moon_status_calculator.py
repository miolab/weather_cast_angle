import ephem


def _get_moon_data(date: bytes, latitude: float, longitude: float) -> ephem.Observer:
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

    return ephem.Moon(observer)


def get_moon_phase(date: bytes, latitude: float, longitude: float) -> str:
    """Calculates the moon phase and returns it's notation.

    Args:
        date (str): 'yyyy/mm/dd' formatted date string.
        latitude (float): target location's latitude.
        longitude (float): target location's longitude.

    Returns:
        str: representing the moon phase.
    """
    # TODO: デバッグ用。あとで消す
    print(date)

    moon = _get_moon_data(date, latitude, longitude)
    phase = moon.phase / 100

    if phase < 0.1:
        return "新月（New Moon）"
    elif phase < 0.2:
        return "三日月（Waxing Crescent）"
    elif phase < 0.3:
        return "上弦の月（First Quarter）"
    elif phase < 0.4:
        return "十日夜月（Waxing Gibbous）"
    elif phase < 0.5:
        return "満月（Full Moon）"
    elif phase < 0.6:
        return "十三夜月（Waning Gibbous）"
    elif phase < 0.7:
        return "下弦の月（Last Quarter）"
    elif phase < 0.8:
        return "居待月（Waning Crescent）"
    else:
        return "新月に近い（New Moon Approaching）"


# TODO: デバッグ用。あとで消す
# python lib/python_manager/py_modules/moon_phase_calculator.py
if __name__ == "__main__":
    print(get_moon_phase(b"2024-01-21", 33.9484466691993, 130.96263530779785))
