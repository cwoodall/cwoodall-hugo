---
title: "Generating Register Maps from PDFs"
date: 2021-01-23T20:12:02-05:00
draft: false
mermaid: true
---

While integrating the [AD7124] into a new firmware design I became frustrated that the PDF tables could not be easily copy-pasted out of to create machine parse-able tables 
for a generator for the register map. With so many registers on board, with lots of configuration bits this was a little frustrating. I started to do the task manually, 
building up the register maps, register structures, and serialization functions by hand. After getting some basic functionality I realized I needed to configure almost
all of the registers on the device. So as a result I went on a search for ["pdf table extraction"][search] and eventually found [Tabula].

The front end [tabula] is sadly not actively maintained anymore (last official release was "June 4, 2018"); however I found it to work reasonably well on the tables in the [AD7124] datasheet. The command line application does seem to be updated, and may be interesting for a repeatable solution (https://github.com/tabulapdf/tabula-java) and even has [python bindings]



<center>
{{<mermaid align="center">}}
graph TB;
    A[Get PDF] --> B(Open In Tabula and Export CSV files)
    B --> C(Separate out Registers, Fields, and Clean Up)
    C --> D[Run Autogenerator]
{{< /mermaid >}}
</center>

[Tabula]: https://tabula.technology/
[AD7124]: https://www.analog.com/media/en/technical-documentation/data-sheets/AD7124-4.pdf
[search]: https://www.google.com/search?q=pdf+table+extraction
[python bindings]: https://github.com/chezou/tabula-py