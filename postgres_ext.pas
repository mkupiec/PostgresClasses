unit postgres_ext;

interface

uses Windows;

{
  Automatically converted by H2Pas 1.0.0 from postgres_ext.h
  The following command line parameters were used:
    -c
    -p
    postgres_ext.h
}

{ Pointers to basic pascal types, inserted by h2pas conversion program.}

Type
{$ifndef PLongint}
  PLongint  = ^Longint;
{$endif}
{$ifndef PSmallInt}
  PSmallInt = ^SmallInt;
{$endif}
{$ifndef PByte}
  PByte     = ^Byte;
{$endif}
{$ifndef PWord}
  PWord     = ^Word;
{$endif}
{$ifndef DWord}
  DWord     = Longint;
{$endif}
{$ifndef PDWord}
  PDWord    = ^DWord;
{$endif}
{$ifndef PDouble}
  PDouble   = ^Double;
{$endif}

{-------------------------------------------------------------------------
 *
 * postgres_ext.h
 *
 *	   This file contains declarations of things that are visible everywhere
 *	in PostgreSQL *and* are visible to clients of frontend interface libraries.
 *	For example, the Oid type is part of the API of libpq and other libraries.
 *
 *	   Declarations which are specific to a particular interface should
 *	go in the header file for that interface (such as libpq-fe.h).	This
 *	file is only for fundamental Postgres declarations.
 *
 *	   User-written C functions don't count as "external to Postgres."
 *	Those function much as local modifications to the backend itself, and
 *	use header files that are otherwise internal to Postgres to interface
 *	with the backend.
 *
 * src/include/postgres_ext.h
 *
 *-------------------------------------------------------------------------
  }

{
 * Object ID is a fundamental type in Postgres.
  }
   POid = ^Oid;
   Oid = dword;

{ was #define dname def_expr }
function InvalidOid : Oid;

const
   // OID_MAX = UINT_MAX;  
   OID_MAX = MAXDWORD;
{ you will need to include <limits.h> to use the above #define  }

// New in Postgres 9.3.2   
{ Define a signed 64-bit integer type for use in client API declarations.  }
type
  Ppg_int64 = ^pg_int64;
  pg_int64 = PG_INT64_TYPE;
  
{
 * Identifiers of error message fields.  Kept here to keep common
 * between frontend and backend, and also to export them to libpq
 * applications.
  }

const
  PG_DIAG_SEVERITY = 'S';  
  PG_DIAG_SQLSTATE = 'C';  
  PG_DIAG_MESSAGE_PRIMARY = 'M';  
  PG_DIAG_MESSAGE_DETAIL = 'D';  
  PG_DIAG_MESSAGE_HINT = 'H';  
  PG_DIAG_STATEMENT_POSITION = 'P';  
  PG_DIAG_INTERNAL_POSITION = 'p';  
  PG_DIAG_INTERNAL_QUERY = 'q';  
  PG_DIAG_CONTEXT = 'W'; 
  
// New in Postgres 9.3.2   
  PG_DIAG_SCHEMA_NAME = 's';  
  PG_DIAG_TABLE_NAME = 't';  
  PG_DIAG_COLUMN_NAME = 'c';  
  PG_DIAG_DATATYPE_NAME = 'd';  
  PG_DIAG_CONSTRAINT_NAME = 'n';  
  
   PG_DIAG_SOURCE_FILE = 'F';   
   PG_DIAG_SOURCE_LINE = 'L';   
   PG_DIAG_SOURCE_FUNCTION = 'R';   

implementation

{ was #define dname def_expr }
function InvalidOid : Oid;
  begin
    InvalidOid:=Oid(0);
  end;


end.
