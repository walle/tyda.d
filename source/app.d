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
  } else {
    write("Search term: "); write(data["search_term"]);
    write("\nLanguage: "); write(data["language"]);
    write("\nWord class: "); write(data["word_class"]);
    write("\nConjucations: ");
    foreach(int i, c; data["conjugations"].array) {
      write(c); 
      if (i < data["conjugations"].array.length-1) {
        write(", ");
      }
    }
    writeln("\nTranslations");
    foreach (t; data["translations"].array) {
      write(t["language"].str);
      if (t["description"].str != "") {
        write(" - ", t["description"].str, "\n");
      } else {
        write("\n");
      }
      foreach (w; t["words"].array) {
        write("  ", w["value"].str);
        if (w["context"].str != "") {
          write(" - ", w["context"].str, "\n");
        } else {
          write("\n");
        }
        if (w["pronunciation_url"].str != "") {
          write("    Pronunciation: ", w["pronunciation_url"].str, "\n");
        }
        if (w["dictionary_url"].str != "") {
          write("    Dictionary: ", w["dictionary_url"].str, "\n");
        }
      }
    }
    if (data["synonyms"].array.length > 0) {
      writeln("\nSynonyms");
      foreach (s; data["synonyms"].array) {
        write(s["value"].str);
        if (s["context"].str != "") {
          write(" - ", s["context"].str);
        }
        write("\n");
      }
    }
    write("\n");
  }
}
