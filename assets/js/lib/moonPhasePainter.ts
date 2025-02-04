export class MoonPhasePainter {
  static init(): void {
    const moonElements = document.querySelectorAll<SVGElement>(
      ".js-moon-phase-area"
    );

    moonElements.forEach((moonElement) => {
      const MOON_PHASE_CYCLE = 29.530589;
      const moonAge = parseFloat(moonElement.dataset.moonAge || "0");

      if (moonAge < 0 || moonAge > MOON_PHASE_CYCLE) return;

      // Get SVG size
      const { width, height } = moonElement.getBoundingClientRect();
      const radius = Math.min(width, height) / 2; // 月の半径

      MoonPhasePainter.setupSVG(moonElement, radius);

      const quarter = MOON_PHASE_CYCLE / 4;
      const { d1, d2 } = MoonPhasePainter.calculateMoonPhase(moonAge, quarter);

      MoonPhasePainter.updatePath(moonElement, d1, d2, radius);
    });
  }

  /**
   * Setup SVG area
   */
  private static setupSVG(moonElement: SVGElement, radius: number): void {
    // Setup SVG attributes
    const diameter = radius * 2;
    moonElement.setAttribute("viewBox", `0 0 ${diameter} ${diameter}`);
    moonElement.setAttribute("xmlns", "http://www.w3.org/2000/svg");

    // Add background circle
    let circle = moonElement.querySelector("circle");
    if (!circle) {
      circle = MoonPhasePainter.createSVGElement("circle", {
        fill: "#605f53",
      });
      moonElement.appendChild(circle);
    }
    circle.setAttribute("cx", radius.toString());
    circle.setAttribute("cy", radius.toString());
    circle.setAttribute("r", radius.toString());

    if (!moonElement.querySelector("path")) {
      const path = MoonPhasePainter.createSVGElement("path");
      moonElement.appendChild(path);
    }
  }

  /**
   * Calculate moon phase
   */
  private static calculateMoonPhase(
    moonAge: number,
    quarter: number
  ): { d1: PhaseData; d2: PhaseData } {
    let age: number;
    let d1: PhaseData;
    let d2: PhaseData;

    if (moonAge < quarter) {
      // 新月から上弦の月
      age = 100 - (moonAge / quarter) * 100;
      d1 = { rx: 100, large_arc_flag: 1, sweep_flag: 1 };
      d2 = { rx: age, large_arc_flag: 1, sweep_flag: 0 };
    } else if (moonAge < 2 * quarter) {
      // 上弦の月から満月
      age = ((moonAge - quarter) / quarter) * 100;
      d1 = { rx: 100, large_arc_flag: 1, sweep_flag: 1 };
      d2 = { rx: age, large_arc_flag: 0, sweep_flag: 1 };
    } else if (moonAge < 3 * quarter) {
      // 満月から下弦の月
      age = 100 - ((moonAge - 2 * quarter) / quarter) * 100;
      d1 = { rx: age, large_arc_flag: 1, sweep_flag: 1 };
      d2 = { rx: 100, large_arc_flag: 0, sweep_flag: 1 };
    } else {
      // 下弦の月から新月
      age = ((moonAge - 3 * quarter) / quarter) * 100;
      d1 = { rx: age, large_arc_flag: 1, sweep_flag: 0 };
      d2 = { rx: 100, large_arc_flag: 0, sweep_flag: 1 };
    }

    return { d1, d2 };
  }

  /**
   * Update SVG path
   */
  private static updatePath(
    moonElement: SVGElement,
    d1: PhaseData,
    d2: PhaseData,
    radius: number
  ): void {
    const path = moonElement.querySelector("path")!;
    const newPath = `
      M ${radius},0 
      A ${(d1.rx / 100) * radius},${radius} 0 ${d1.large_arc_flag},${
      d1.sweep_flag
    } ${radius},${radius * 2} 
      A ${(d2.rx / 100) * radius},${radius} 0 ${d2.large_arc_flag},${
      d2.sweep_flag
    } ${radius},0 
      Z
    `;
    path.setAttribute("d", newPath);
    path.setAttribute("fill", "#ffcf33");
  }

  private static createSVGElement(
    tag: string,
    attributes: Record<string, string> = {}
  ): SVGElement {
    const element = document.createElementNS("http://www.w3.org/2000/svg", tag);
    Object.entries(attributes).forEach(([key, value]) =>
      element.setAttribute(key, value)
    );
    return element;
  }
}

interface PhaseData {
  rx: number;
  large_arc_flag: number;
  sweep_flag: number;
}
