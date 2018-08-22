# coding=utf-8
import setuptools

with open("README.adoc", "r") as fh:
    long_description = fh.read()

setuptools.setup(
    name="newdoc",
    version="1.2",
    author="Marek Suchánek",
    author_email="marek.suchanek@protonmail.com",
    description="A script to generate assembly and module AsciiDoc files from templates.",
    long_description=long_description,
    long_description_content_type="text/asciidoc",
    url="https://github.com/mrksu/tools/tree/master/newdoc",
    packages=setuptools.find_packages(),
    classifiers=[
        "Programming Language :: Python :: 2",
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: GNU General Public License v3 or later (GPLv3+)",
        "Operating System :: OS Independent",
        "Environment :: Console",
        "Topic :: Documentation",
        "Topic :: Text Processing :: Markup"
    ],
)
