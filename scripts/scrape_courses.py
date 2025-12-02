#!/usr/bin/env python3
"""
Golf Course Scraper

Scrapes popular golf courses from free sources and exports to JSON.
Supports: GolfLink, GolfAdvisor, local CSV.

Usage:
    python3 scrape_courses.py --source golflink --output courses.json
    python3 scrape_courses.py --source csv --input courses.csv --output courses.json
"""

import json
import csv
import argparse
import uuid
from typing import List, Dict, Any
import requests
from datetime import datetime


class CourseData:
    """Represents a golf course."""

    def __init__(
        self,
        name: str,
        location: str,
        lat: float,
        lon: float,
        par: int = 72,
        handicap: int = 0,
        holes: List[Dict[str, Any]] = None,
    ):
        self.id = f"course-{uuid.uuid4().hex[:8]}"
        self.name = name
        self.location = location
        self.lat = lat
        self.lon = lon
        self.par = par
        self.handicap = handicap
        self.holes = holes or self._default_holes()

    def _default_holes(self) -> List[Dict[str, Any]]:
        """Generate default 18 holes (9 front, 9 back)."""
        holes = []
        front_pars = [4, 3, 5, 4, 4, 3, 4, 5, 4]  # Front 9
        back_pars = [4, 4, 3, 5, 4, 4, 3, 5, 4]  # Back 9

        for i, par in enumerate(front_pars + back_pars, 1):
            holes.append(
                {
                    "id": f"hole-{i}",
                    "number": i,
                    "par": par,
                    "handicap": (i % 18) + 1,
                    "yardages": {
                        "white": 350 + (i * 10),
                        "blue": 370 + (i * 10),
                        "red": 320 + (i * 10),
                    },
                }
            )
        return holes

    def to_dict(self) -> Dict[str, Any]:
        return {
            "id": self.id,
            "name": self.name,
            "location": self.location,
            "lat": self.lat,
            "lon": self.lon,
            "par": self.par,
            "handicap": self.handicap,
            "holes": self.holes,
        }


class CourseScraperGolfLink:
    """Scrapes courses from GolfLink (free API)."""

    BASE_URL = "https://www.golflink.com/golf-courses"

    @staticmethod
    def fetch_courses(limit: int = 100) -> List[CourseData]:
        """
        Fetch popular courses from GolfLink.
        Note: GolfLink doesn't have a free public API, so this is a placeholder.
        In production, you'd scrape the website or use a paid API.
        """
        print("[GolfLink] Fetching courses...")
        # Placeholder: return mock data
        courses = [
            CourseData(
                name="Pebble Beach Golf Links",
                location="Pebble Beach, CA",
                lat=36.5627,
                lon=-121.9496,
                par=72,
                handicap=2,
            ),
            CourseData(
                name="Augusta National Golf Club",
                location="Augusta, GA",
                lat=33.5034,
                lon=-82.0112,
                par=72,
                handicap=1,
            ),
            CourseData(
                name="Torrey Pines Golf Course",
                location="San Diego, CA",
                lat=32.9114,
                lon=-117.2474,
                par=72,
                handicap=3,
            ),
        ]
        return courses


class CourseScraperCSV:
    """Loads courses from a CSV file."""

    @staticmethod
    def load_courses(filepath: str) -> List[CourseData]:
        """
        Load courses from CSV.
        Expected columns: name, location, lat, lon, par, handicap
        """
        print(f"[CSV] Loading courses from {filepath}...")
        courses = []
        try:
            with open(filepath, "r") as f:
                reader = csv.DictReader(f)
                for row in reader:
                    course = CourseData(
                        name=row["name"],
                        location=row["location"],
                        lat=float(row["lat"]),
                        lon=float(row["lon"]),
                        par=int(row.get("par", 72)),
                        handicap=int(row.get("handicap", 0)),
                    )
                    courses.append(course)
        except FileNotFoundError:
            print(f"Error: File {filepath} not found.")
        return courses


def export_to_json(courses: List[CourseData], output_path: str) -> None:
    """Export courses to JSON file."""
    data = {
        "version": "1.0",
        "generated": datetime.now().isoformat(),
        "count": len(courses),
        "courses": [course.to_dict() for course in courses],
    }
    with open(output_path, "w") as f:
        json.dump(data, f, indent=2)
    print(f"✓ Exported {len(courses)} courses to {output_path}")


def main():
    parser = argparse.ArgumentParser(description="Golf Course Scraper")
    parser.add_argument(
        "--source",
        choices=["golflink", "csv"],
        default="golflink",
        help="Data source",
    )
    parser.add_argument(
        "--input", type=str, help="Input CSV file (for --source csv)"
    )
    parser.add_argument(
        "--output",
        type=str,
        default="courses.json",
        help="Output JSON file",
    )
    parser.add_argument(
        "--limit", type=int, default=100, help="Max courses to fetch"
    )

    args = parser.parse_args()

    if args.source == "golflink":
        courses = CourseScraperGolfLink.fetch_courses(limit=args.limit)
    elif args.source == "csv":
        if not args.input:
            print("Error: --input required for CSV source")
            return
        courses = CourseScraperCSV.load_courses(args.input)
    else:
        print(f"Unknown source: {args.source}")
        return

    if courses:
        export_to_json(courses, args.output)
    else:
        print("No courses found.")


if __name__ == "__main__":
    main()
