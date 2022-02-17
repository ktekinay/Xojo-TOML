# Xojo-TOML

A Xojo TOML conversion library

## Description

This implements the `ParseTOML_MTC` and `GenerateTOML_MTC` functions that work with [TOML](https://toml.io) the way the native `ParseJSON` and `GenerateJSON` work with JSON.

## Installation

Open the *M_TOML Harness.xojo_project* file and copy the `M_TOML` module into your own project. **Do not drag the module directly from the disk folder into your project.**

## Basic Usage

`ParseTOML_MTC` will take a TOML-formatted string and return a **`Dictionary`**. If there is an error during parsing, you will get a **`M_TOML.TOMLException`** exception.

```
var d as Dictionary = ParseTOML_MTC( tomlString )
```

**Note**: Like JSON, TOML is case-sensitive and the resulting **`Dictionary`** will be case-sensitive too.

`GenerateTOML_MTC` will take a **`Dictionary`** and return a TOML-formatted string. If there is an error, you will get some exception, probably because the **`Dictionary`** includes some data type that cannot be properly converted.

```
var tomlString as string = GenerateTOML_MTC( someDictionary )
```

## Advanced Stuff

TOML will allow you to encode a **`Dictionary`** (their term is "table") either as sections or inline.

As a section:

```
[ toml ]
  a = 1
  b = 2
```

As inline:

```
toml = { a = 1, b = 2 }
```

This only makes a difference visually, but if you want to force an inline **`Dictionary`** from `GenerateTOML_MTC`, use the **`M_TOML.InlineDictionary`** class.

TOML allows encoding of a **`DateTime`** either with or without a time zone. Examples:

```
a = 2022-01-02T13:01:23Z      # GMT
a = 2022-01-02T13:01:21-05:00 # Eastern Standard Time (GMT - 5)
a = 2022-01-02T13:01:21       # Local date and time, no time zone
```

If you want a local time, use the **`M_TOML.LocalDateTime`** class, a subclass of **`DateTime`**.

**Note**: If a **`M_TOML.LocalDateTime`** is set to midnight, it will be encoded without the time, e.g., "a = 2022-01-02".

TOML includes encoding of a local time, such as:

```
a = 01:02:03.123
```

For this purpose, you can use the **`M_TOML.LocalTime`** class.

**Note**: While similar to **`DateTime`**, the **`M_TOML.LocalTime`** class is not a subclass of an existing Xojo class.

## Comments and Contributions

All contributions to this project will be gratefully considered. Fork this repo to your own, then submit your changes via a Pull Request.

All comments are also welcome.

## Who Did This?!?

This project was created by and is maintained by Kem Tekinay (ktekinay@mactechnologies dot com).

## Release Notes

- 1.0 ( ____  )
