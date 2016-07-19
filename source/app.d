import std.stdio;
import std.getopt;
import std.process;
import std.json;

import core.stdc.stdlib;

string query;
string[] languages = ["en"];
bool shortOutput;

void main(string[] args)
{
	arraySep = ",";
	auto helpInformation = getopt(
    args,
    "languages|l",    &languages,
    "short|s", &shortOutput);

	if (helpInformation.helpWanted)
  {
    defaultGetoptPrinter("usage: tyda.d [--simple] [--languages LANGUAGES] QUERY",
      helpInformation.options);
    exit(0);
  }

  if (args.length < 2) {
    writeln("QUERY is required");
    defaultGetoptPrinter("usage: tyda.d [--simple] [--languages LANGUAGES] QUERY",
      helpInformation.options);
    exit(1);
  }
  query = args[args.length-1];
  
  auto search = execute(["tyda-api", query]);
  if (search.status != 0) {
    writeln("Failed to retrieve data");
    exit(1);
  }

  JSONValue data = parseJSON(search.output);

  if (shortOutput) {
    foreach (t; data["translations"].array) {
      foreach (w; t["words"].array) {
        write(w["value"].str, " ");
      }
    }
    write("\n");
    if (data["synonyms"].array.length > 0) {
      write("Synonyms: ");
      foreach (s; data["synonyms"].array) {
        write(s["value"].str, " ");
      }
      write("\n");
    }
  }
}
