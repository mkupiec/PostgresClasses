{-------------------------------------------------------------------------
 *
 * libpq-fe.h
 *	  This file contains definitions for structures and
 *	  externs for functions used by frontend postgres applications.
 *
 * Portions Copyright (c) 1996-2013, PostgreSQL Global Development Group
 * Portions Copyright (c) 1994, Regents of the University of California
 *
 * src/interfaces/libpq/libpq-fe.h
 *
 *-------------------------------------------------------------------------}

{
  Automatically converted by H2Pas 1.0.0 from libpq-fe.h (Postgres 9.3.2)
  The following command line parameters were used:
    -c
    -p
    libpq-fe.h
}
 
unit libpq_fe;

interface

uses
  SysUtils,
  postgres_ext; // postgres_ext.h defines the backend's externally visible
                // types, such as Oid.

{ Pointers to basic pascal types, inserted by h2pas conversion program. }

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
{$ifndef PDWord}
  PDWord    = ^DWord;
{$endif}
{$ifndef PDouble}
  PDouble   = ^Double;
{$endif}

  PFILE  = ^FILE;
  size_t = dword;
  Psize_t  = ^size_t;
  PIntegers = array of integer;
  PPChars = array of PAnsiChar;  // const char *const * paramName

{
Type
P_PQconninfoOption  = ^_PQconninfoOption;
P_PQprintOpt  = ^_PQprintOpt;

// New in Postgres 9.3.2
Pbyte  = ^byte;
PAnsiChar  = ^char;

PConnStatusType  = ^ConnStatusType;
PExecStatusType  = ^ExecStatusType;
PFILE  = ^FILE;

// New in Postgres 9.3.2
Plongint  = ^longint;

POid  = ^Oid;
PPGcancel  = ^PGcancel;
PPGconn  = ^PGconn;
PpgNotify  = ^pgNotify;

// New in Postgres 9.3.2
PPGPing  = ^PGPing;

PpgresAttDesc  = ^pgresAttDesc;
PPGresult  = ^PGresult;
PPGTransactionStatusType  = ^PGTransactionStatusType;
PPGVerbosity  = ^PGVerbosity;
PPostgresPollingStatusType  = ^PostgresPollingStatusType;
PPQArgBlock  = ^PQArgBlock;
Ppqbool  = ^pqbool;
PPQconninfoOption  = ^PQconninfoOption;
PPQprintOpt  = ^PQprintOpt;
Psize_t  = ^size_t;
}

const

   libpq = 'libpq.dll';

{ Option flags for PQcopyResult }

   PG_COPYRES_ATTRS = $01;
   PG_COPYRES_TUPLES = $02; // Implies PG_COPYRES_ATTRS
   PG_COPYRES_EVENTS = $04;
   PG_COPYRES_NOTICEHOOKS = $08;

{ Error when no password was given.  }
{ Note: depending on this is deprecated; use PQconnectionNeedsPassword().  }

   PQnoPasswordSupplied = 'fe_sendauth: no password supplied\n';

   PG_PARAMTYPE_STRING	= 0;
   PG_PARAMTYPE_BINARY	= 1;

{ Application-visible enum types  }

{ Although it is okay to add to these lists, values which become unused
  should never be removed, nor should constants be redefined - that would
  break compatibility with existing code. }

type

   PConnStatusType = ^ConnStatusType;
   ConnStatusType = ( CONNECTION_OK,
                      CONNECTION_BAD,
                      { Non-blocking mode only below here  }

                      { The existence of these should never be relied upon -
                        they should only be used for user feedback or similar
                        purposes. }
                        
                      CONNECTION_STARTED,            // Waiting for connection to be made.
                      CONNECTION_MADE,               // Connection OK; waiting to send.
                      CONNECTION_AWAITING_RESPONSE,  // Waiting for a response from the postmaster.
                      CONNECTION_AUTH_OK,            // Received authentication; waiting for backend startup.
                      CONNECTION_SETENV,             // Negotiating environment.
                      CONNECTION_SSL_STARTUP,        // Negotiating SSL.
                      CONNECTION_NEEDED );           // Internal state: connect() needed.

   PPostgresPollingStatusType = ^PostgresPollingStatusType;
   PostgresPollingStatusType = ( PGRES_POLLING_FAILED = 0,    // := 0
                                 PGRES_POLLING_READING,       // These two indicate that one may
                                 PGRES_POLLING_WRITING,       // use select before polling again.
                                 PGRES_POLLING_OK,
                                 PGRES_POLLING_ACTIVE );      // unused; keep for awhile for backwards compatibility

   PExecStatusType = ^ExecStatusType;
   ExecStatusType = ( PGRES_EMPTY_QUERY = 0,    // := 0
                                                // empty query string was executed
                      PGRES_COMMAND_OK,         // a query command that doesn't return
                                                // anything was executed properly by the backend
                      PGRES_TUPLES_OK,          // a query command that returns tuples was
                                                // executed properly by the backend, PGresult
                                                // contains the result tuples
                      PGRES_COPY_OUT,           // Copy Out data transfer in progress
                      PGRES_COPY_IN,            // Copy In data transfer in progress
                      PGRES_BAD_RESPONSE,       // an unexpected response was recv'd from the backend
                      PGRES_NONFATAL_ERROR,     // notice or warning message
                      PGRES_FATAL_ERROR,        // query failed

                      // New in Postgres 9.3.2
                      PGRES_COPY_BOTH,          // Copy In/Out data transfer in progress
                      PGRES_SINGLE_TUPLE);      // single tuple from larger resultset

   PPGTransactionStatusType = ^PGTransactionStatusType;
   PGTransactionStatusType = ( PQTRANS_IDLE,       // connection idle
                               PQTRANS_ACTIVE,     // command in progress
                               PQTRANS_INTRANS,    // idle, within transaction block
                               PQTRANS_INERROR,    // idle, within failed transaction
                               PQTRANS_UNKNOWN );  // cannot determine status

   PPGVerbosity = ^PGVerbosity;
   PGVerbosity = ( PQERRORS_TERSE,      // single-line error messages
                   PQERRORS_DEFAULT,    // recommended style
                   PQERRORS_VERBOSE );  // all the facts, ma'am

   // New in Postgres 9.3.2
   { PGPing - The ordering of this enum should not be altered because the
     values are exposed externally via pg_isready. }
   PPGPing = ^PGPing;
   PGPing = ( PQPING_OK,            // server is accepting connections 
              PQPING_REJECT,        // server is alive but rejecting connections
              PQPING_NO_RESPONSE,   // could not establish connection
              PQPING_NO_ATTEMPT );  // connection not attempted (bad params)

   { PGconn encapsulates a connection to the backend.
     The contents of this struct are not supposed to be known to applications. }

   //pg_conn = PGconn;
   PPGconn = pointer;

   { PGresult encapsulates the result of a query (or more precisely, of a single
     SQL command --- a query string given to PQsendQuery can contain multiple
     commands and thus return multiple PGresult objects).
     The contents of this struct are not supposed to be known to applications. }

   //pg_result = PGresult;
   PPGresult = pointer;

   { PGcancel encapsulates the information needed to cancel a running
     query on an existing connection.
     The contents of this struct are not supposed to be known to applications. }

   //pg_cancel = PGcancel;
   PPGcancel = pointer;

   { PGnotify represents the occurrence of a NOTIFY message.
     Ideally this would be an opaque typedef, but it's so simple that it's
     unlikely to change.
     NOTE: in Postgres 6.4 and later, the be_pid is the notifying backend's,
     whereas in earlier versions it was always your own backend's PID. }
  
   PpgNotify = ^pgNotify;
   pgNotify = record
        relname : PAnsiChar;  // notification condition name
        be_pid : longint;     // process ID of notifying server process
        extra : PAnsiChar;    // notification parameter
        { Fields below here are private to libpq; apps should not use 'em }
        next : PpgNotify;     // list link
     end;

   { Function types for notice-handling callbacks }

   PQnoticeReceiver = procedure (arg:pointer; res:PPGresult); cdecl;
   PQnoticeProcessor = procedure (arg:pointer; message:PAnsiChar); cdecl;

   { Print options for PQprint() }

   Ppqbool = ^pqbool;
   pqbool = char;   

   P_PQprintOpt = ^_PQprintOpt;
   _PQprintOpt = record
        header : pqbool;          // print output field headings and row count
        align : pqbool;           // fill align the fields
        standard : pqbool;        // old brain dead format
        html3 : pqbool;           // output html tables
        expanded : pqbool;        // expand tables
        pager : pqbool;           // use pager for output if needed
        fieldSep : PAnsiChar;     // field separator
        tableOpt : PAnsiChar;     // insert to HTML <table ...>
        caption : PAnsiChar;      // HTML <caption>
        fieldName : ^PAnsiChar;   // null terminated array of replacement field names
     end;
   PQprintOpt = _PQprintOpt;
   PPQprintOpt = ^PQprintOpt;

{ ----------------
  Structure for the conninfo parameter definitions returned by PQconndefaults
  or PQconninfoParse.

  All fields except "val" point at static strings which must not be altered.
  "val" is either NULL or a malloc'd current-value string.  PQconninfoFree()
  will release both the val strings and the PQconninfoOption array itself.
 * ----------------}

   P_PQconninfoOption = ^_PQconninfoOption;
   _PQconninfoOption = record
        keyword : PAnsiChar;   // The keyword of the option
        envvar : PAnsiChar;    // Fallback environment variable name
        compiled : PAnsiChar;  // Fallback compiled in default value
        val : PAnsiChar;       // Option's current value, or NULL
        _label : PAnsiChar;    // Label for field in connect dialog
        dispchar : PAnsiChar;  { Indicates how to display this field in a
					              			   connect dialog. Values are: "" Display
                                 entered value as is "*" Password field -
								                 hide value "D"  Debug option - don't show
								                 by default  }
        dispsize : longint;    // Field size in characters for dialog
     end;
   PQconninfoOption = _PQconninfoOption;
   PPQconninfoOption = ^PQconninfoOption;

{ ----------------
  PQArgBlock -- structure for PQfn() arguments
  ---------------- }

   PPQArgBlock = ^PQArgBlock;
   PQArgBlock = record
        len : longint;
        isint : longint;
        u : record
            case longint of
               0 : ( ptr : Plongint );      { can't use void (dec compiler barfs)	}
               1 : ( integer : longint );
            end;
     end;

{ ----------------
  PGresAttDesc -- Data about a single attribute (column) of a query result
  ---------------- }

   PpgresAttDesc = ^pgresAttDesc;
   pgresAttDesc = record
        name : PAnsiChar;     // column name
        tableid : Oid;        // source table, if known
        columnid : longint;   // source column, if known
        format : longint;     // format code for value (text/binary)
        typid : Oid;          // type id
        typlen : longint;     // type size
        atttypmod : longint;  // type-specific modifier info
     end;

   pgthreadlock_t = procedure (acquire:longint); cdecl;

   { Exported functions of libpq }

   { ===	in fe-connect.c === }
   { make a new client connection to the backend }

   { Asynchronous (non-blocking) }

   function PQconnectStart(conninfo:PAnsiChar):PPGconn; cdecl;

   // New in Postgres 9.3.2
   { /* New in Postgres 9.3.2: */
   extern PGconn *PQconnectStartParams(const char *const * keywords,
					 const char *const * values, int expand_dbname);
   /* New in Postgres 9.3.2. */ }                               
   function PQconnectStartParams(keywords:PPChars; values:PPChars; expand_dbname:longint):PPGconn; cdecl;

   function PQconnectPoll(conn:PPGconn):PostgresPollingStatusType; cdecl;

   { Synchronous (blocking) }

   function PQconnectdb(conninfo:PAnsiChar):PPGconn; cdecl;

   // New in Postgres 9.3.2
   { /* New in Postgres 9.3.2: */
   extern PGconn *PQconnectdbParams(const char *const * keywords,
				  const char *const * values, int expand_dbname);
   /* New in Postgres 9.3.2. */ }                          
   function PQconnectdbParams(keywords:PPChars; values:PPChars; expand_dbname:longint):PPGconn; cdecl;

   function PQsetdbLogin(pghost:PAnsiChar; pgport:PAnsiChar; pgoptions:PAnsiChar; pgtty:PAnsiChar; dbName:PAnsiChar;
           login:PAnsiChar; pwd:PAnsiChar):PPGconn; cdecl;

   { was #define dname(params) para_def_expr }
   { argument types are unknown }
   { return type might be wrong }
   // function PQsetdb(M_PGHOST,M_PGPORT,M_PGOPT,M_PGTTY,M_DBNAME : longint) : longint;
   function PQsetdb(M_PGHOST,M_PGPORT,M_PGOPT,M_PGTTY,M_DBNAME : PAnsiChar) : PPGconn;

   { close the current connection and free the PGconn data structure  }
   procedure PQfinish(conn:PPGconn); cdecl;

   { get info about connection options known to PQconnectdb  }
   function PQconndefaults:PPQconninfoOption; cdecl;

   { parse connection options in same way as PQconnectdb  }
   function PQconninfoParse(conninfo:PAnsiChar; errmsg:PPchar):PPQconninfoOption; cdecl;

   // New in Postgres 9.3.2
   // return the connection options used by a live connection
   function PQconninfo(conn:PPGconn):PPQconninfoOption; cdecl;

   { free the data structure returned by PQconndefaults() or PQconninfoParse()  }
   procedure PQconninfoFree(connOptions:PPQconninfoOption); cdecl;

   { close the current connection and restablish a new one with the same
     parameters }

   { Asynchronous (non-blocking) }
   function PQresetStart(conn:PPGconn):longint; cdecl;
   function PQresetPoll(conn:PPGconn):PostgresPollingStatusType; cdecl;

   { Synchronous (blocking)  }
   procedure PQreset(conn:PPGconn); cdecl;

   { request a cancel structure  }
   function PQgetCancel(conn:PPGconn):PPGcancel; cdecl;

   { free a cancel structure  }
   procedure PQfreeCancel(cancel:PPGcancel); cdecl;

   { issue a cancel request  }
   function PQcancel(cancel:PPGcancel; errbuf:PAnsiChar; errbufsize:longint):longint; cdecl;

   { backwards compatible version of PQcancel; not thread-safe  }
   function PQrequestCancel(conn:PPGconn):longint; cdecl;

   { Accessor functions for PGconn objects  }
   function PQdb(conn:PPGconn):PAnsiChar; cdecl;
   function PQuser(conn:PPGconn):PAnsiChar; cdecl;
   function PQpass(conn:PPGconn):PAnsiChar; cdecl;
   function PQhost(conn:PPGconn):PAnsiChar; cdecl;
   function PQport(conn:PPGconn):PAnsiChar; cdecl;
   function PQtty(conn:PPGconn):PAnsiChar; cdecl;
   function PQoptions(conn:PPGconn):PAnsiChar; cdecl;
   function PQstatus(conn:PPGconn):ConnStatusType; cdecl;
   function PQtransactionStatus(conn:PPGconn):PGTransactionStatusType; cdecl;
   function PQparameterStatus(conn:PPGconn; paramName:PAnsiChar):PAnsiChar; cdecl;
   function PQprotocolVersion(conn:PPGconn):longint; cdecl;
   function PQserverVersion(conn:PPGconn):longint; cdecl;
   function PQerrorMessage(conn:PPGconn):PAnsiChar; cdecl;
   function PQsocket(conn:PPGconn):longint; cdecl;
   function PQbackendPID(conn:PPGconn):longint; cdecl;
   function PQconnectionNeedsPassword(conn:PPGconn):longint; cdecl;
   function PQconnectionUsedPassword(conn:PPGconn):longint; cdecl;
   function PQclientEncoding(conn:PPGconn):longint; cdecl;
   function PQsetClientEncoding(conn:PPGconn; encoding:PAnsiChar):longint; cdecl;

   { Get the OpenSSL structure associated with a connection. Returns NULL for
     unencrypted connections or if any other TLS library is in use. }
   function PQgetssl(conn:PPGconn):pointer; cdecl;

   { Tell libpq whether it needs to initialize OpenSSL }
   procedure PQinitSSL(do_init:longint); cdecl;

   { More detailed way to tell libpq whether it needs to initialize OpenSSL }
   procedure PQinitOpenSSL(do_ssl:longint; do_crypto:longint); cdecl;

   { Set verbosity for PQerrorMessage and PQresultErrorMessage }
   function PQsetErrorVerbosity(conn:PPGconn; verbosity:PGVerbosity):PGVerbosity; cdecl;

   { Enable/disable tracing }
   procedure PQtrace(conn:PPGconn; debug_port:PFILE); cdecl;
   procedure PQuntrace(conn:PPGconn); cdecl;

   { Override default notice handling routines  }
   function PQsetNoticeReceiver(conn:PPGconn; proc:PQnoticeReceiver; arg:pointer):PQnoticeReceiver; cdecl;
   function PQsetNoticeProcessor(conn:PPGconn; proc:PQnoticeProcessor; arg:pointer):PQnoticeProcessor; cdecl;

   { Used to set callback that prevents concurrent access to
     non-thread safe functions that libpq needs.
     The default implementation uses a libpq internal mutex.
     Only required for multithreaded apps that use kerberos
     both within their app and for postgresql connections. }
   function PQregisterThreadLock(newhandler:pgthreadlock_t):pgthreadlock_t; cdecl;

   { === in fe-exec.c ===  }

   { Simple synchronous query  }

   function PQexec(conn:PPGconn; query:PAnsiChar):PPGresult; cdecl;

   // function PQexecParams(conn:PPGconn; command:PAnsiChar; nParams:longint; paramTypes:POid; paramValues:PPchar;
   //            paramLengths:Plongint; paramFormats:Plongint; resultFormat:longint):PPGresult; cdecl;
   function PQexecParams(conn:PPGconn; command:PAnsiChar; nParams:longint; paramTypes:POid; paramValues: PPChars;
           paramLengths: PIntegers; paramFormats: PIntegers; resultFormat:longint):PPGresult; cdecl;

   function PQprepare(conn:PPGconn; stmtName:PAnsiChar; query:PAnsiChar; nParams:longint; paramTypes:POid):PPGresult; cdecl;

   // function PQexecPrepared(conn:PPGconn; stmtName:PAnsiChar; nParams:longint; paramValues:PPchar; paramLengths:Plongint;
   //            paramFormats:Plongint; resultFormat:longint):PPGresult; cdecl;
   function PQexecPrepared(conn:PPGconn; stmtName:PAnsiChar; nParams:longint; paramValues: PPChars; paramLengths:PIntegers;
           paramFormats:PIntegers; resultFormat:longint):PPGresult; cdecl;

   { Interface for multiple-result or asynchronous queries  }

   function PQsendQuery(conn:PPGconn; query:PAnsiChar):longint; cdecl;

   // function PQsendQueryParams(conn:PPGconn; command:PAnsiChar; nParams:longint; paramTypes:POid; paramValues:PPchar;
   //            paramLengths:Plongint; paramFormats:Plongint; resultFormat:longint):longint; cdecl;
   function PQsendQueryParams(conn:PPGconn; command:PAnsiChar; nParams:longint; paramTypes:POid; paramValues: PPChars;
           paramLengths:Plongint; paramFormats:Plongint; resultFormat:longint):longint; cdecl;

   function PQsendPrepare(conn:PPGconn; stmtName:PAnsiChar; query:PAnsiChar; nParams:longint; paramTypes:POid):longint; cdecl;

   // function PQsendQueryPrepared(conn:PPGconn; stmtName:PAnsiChar; nParams:longint; paramValues:PPchar; paramLengths:Plongint;
   //            paramFormats:Plongint; resultFormat:longint):longint; cdecl;
   function PQsendQueryPrepared(conn:PPGconn; stmtName:PAnsiChar; nParams:longint; paramValues: PPChars; paramLengths:Plongint;
           paramFormats:Plongint; resultFormat:longint):longint; cdecl;

   // New in Postgres 9.3.2
   function PQsetSingleRowMode(conn:PPGconn):longint; cdecl;

   function PQgetResult(conn:PPGconn):PPGresult; cdecl;

   { Routines for managing an asynchronous query  }
   function PQisBusy(conn:PPGconn):longint; cdecl;
   function PQconsumeInput(conn:PPGconn):longint; cdecl;

   { LISTEN/NOTIFY support  }
   function PQnotifies(conn:PPGconn):PPGnotify; cdecl;

   { Routines for copy in/out  }
   function PQputCopyData(conn:PPGconn; buffer:PAnsiChar; nbytes:longint):longint; cdecl;
   function PQputCopyEnd(conn:PPGconn; errormsg:PAnsiChar):longint; cdecl;
   function PQgetCopyData(conn:PPGconn; buffer:PPchar; async:longint):longint; cdecl;

   { Deprecated routines for copy in/out  }
   function PQgetline(conn:PPGconn; _string:PAnsiChar; length:longint):longint; cdecl;
   function PQputline(conn:PPGconn; _string:PAnsiChar):longint; cdecl;
   function PQgetlineAsync(conn:PPGconn; buffer:PAnsiChar; bufsize:longint):longint; cdecl;
   function PQputnbytes(conn:PPGconn; buffer:PAnsiChar; nbytes:longint):longint; cdecl;
   function PQendcopy(conn:PPGconn):longint; cdecl;

   { Set blocking/nonblocking connection to the backend  }
   function PQsetnonblocking(conn:PPGconn; arg:longint):longint; cdecl;
   function PQisnonblocking(conn:PPGconn):longint; cdecl;
   function PQisthreadsafe:longint; cdecl;

   // New in Postgres 9.3.2
   { /* New in Postgres 9.3.2: */
   extern PGPing PQping(const char *conninfo);
   /* New in Postgres 9.3.2. */ }                  
   function PQping(conninfo:PAnsiChar):PGPing; cdecl;

   // New in Postgres 9.3.2
   { /* New in Postgres 9.3.2: */
   extern PGPing PQpingParams(const char *const * keywords,
			 const char *const * values, int expand_dbname);
   /* New in Postgres 9.3.2. */ }                       
   function PQpingParams(keywords:PPChars; values:PPChars; expand_dbname:longint):PGPing; cdecl;

   { Force the write buffer to be written (or at least try)  }
   function PQflush(conn:PPGconn):longint; cdecl;

   { "Fast path" interface --- not really recommended for application use }
   function PQfn(conn:PPGconn; fnid:longint; result_buf:Plongint; result_len:Plongint; result_is_int:longint;
           args:PPQArgBlock; nargs:longint):PPGresult; cdecl;

   { Accessor functions for PGresult objects  }

   function PQresultStatus(res:PPGresult):ExecStatusType; cdecl;
   function PQresStatus(status:ExecStatusType):PAnsiChar; cdecl;
   function PQresultErrorMessage(res:PPGresult):PAnsiChar; cdecl;
   function PQresultErrorField(res:PPGresult; fieldcode:longint):PAnsiChar; cdecl;
   function PQntuples(res:PPGresult):longint; cdecl;
   function PQnfields(res:PPGresult):longint; cdecl;
   function PQbinaryTuples(res:PPGresult):longint; cdecl;
   function PQfname(res:PPGresult; field_num:longint):PAnsiChar; cdecl;
   function PQfnumber(res:PPGresult; field_name:PAnsiChar):longint; cdecl;
   function PQftable(res:PPGresult; field_num:longint):Oid; cdecl;
   function PQftablecol(res:PPGresult; field_num:longint):longint; cdecl;
   function PQfformat(res:PPGresult; field_num:longint):longint; cdecl;
   function PQftype(res:PPGresult; field_num:longint):Oid; cdecl;
   function PQfsize(res:PPGresult; field_num:longint):longint; cdecl;
   function PQfmod(res:PPGresult; field_num:longint):longint; cdecl;
   function PQcmdStatus(res:PPGresult):PAnsiChar; cdecl;
   function PQoidStatus(res:PPGresult):PAnsiChar; cdecl; { old and ugly }
   function PQoidValue(res:PPGresult):Oid; cdecl; { new and improved }
   function PQcmdTuples(res:PPGresult):PAnsiChar; cdecl;
   function PQgetvalue(res:PPGresult; tup_num:longint; field_num:longint):PAnsiChar; cdecl;
   function PQgetlength(res:PPGresult; tup_num:longint; field_num:longint):longint; cdecl;
   function PQgetisnull(res:PPGresult; tup_num:longint; field_num:longint):longint; cdecl;
   function PQnparams(res:PPGresult):longint; cdecl;
   function PQparamtype(res:PPGresult; param_num:longint):Oid; cdecl;

   { Describe prepared statements and portals }
   function PQdescribePrepared(conn:PPGconn; stmt:PAnsiChar):PPGresult; cdecl;
   function PQdescribePortal(conn:PPGconn; portal:PAnsiChar):PPGresult; cdecl;
   function PQsendDescribePrepared(conn:PPGconn; stmt:PAnsiChar):longint; cdecl;
   function PQsendDescribePortal(conn:PPGconn; portal:PAnsiChar):longint; cdecl;

   { Delete a PGresult  }
   procedure PQclear(res:PPGresult); cdecl;

   { For freeing other alloc'd results, such as PGnotify structs  }
   procedure PQfreemem(ptr:pointer); cdecl;

   { Exists for backward compatibility.  bjm 2003-03-24  }
   { was #define dname(params) para_def_expr }
   { argument types are unknown }
   { return type might be wrong }
   // function PQfreeNotify(ptr : longint) : longint;
   procedure PQfreeNotify(ptr : pointer);

   { Create and manipulate PGresults  }
   function PQmakeEmptyPGresult(conn:PPGconn; status:ExecStatusType):PPGresult; cdecl;
   function PQcopyResult(src:PPGresult; flags:longint):PPGresult; cdecl;
   function PQsetResultAttrs(res:PPGresult; numAttributes:longint; attDescs:PPGresAttDesc):longint; cdecl;
   function PQresultAlloc(res:PPGresult; nBytes:size_t):pointer; cdecl;
   function PQsetvalue(res:PPGresult; tup_num:longint; field_num:longint; value:PAnsiChar; len:longint):longint; cdecl;

   { Quoting strings before inclusion in queries.  }

   // function PQescapeStringConn(conn:PPGconn; to:PAnsiChar; from:PAnsiChar; length:size_t; error:Plongint):size_t; cdecl;
   function PQescapeStringConn(conn:PPGconn; c_to:PAnsiChar; from:PAnsiChar; length:size_t; error:Plongint):size_t; cdecl;

   // New in Postgres 9.3.2
   function PQescapeLiteral(conn:PPGconn; str:PAnsiChar; len:size_t):PAnsiChar; cdecl;
   function PQescapeIdentifier(conn:PPGconn; str:PAnsiChar; len:size_t):PAnsiChar; cdecl;

   // function PQescapeByteaConn(conn:PPGconn; from:Pbyte; from_length:size_t; to_length:Psize_t):Pbyte; cdecl;
   function PQescapeByteaConn(conn:PPGconn; from:PByte; from_length:size_t; to_length:Psize_t):PByte; cdecl;

   // function PQunescapeBytea(strtext:Pbyte; retbuflen:Psize_t):Pbyte; cdecl;
   function PQunescapeBytea(strtext:PByte; retbuflen:Psize_t):PByte; cdecl;

   { These forms are deprecated!  }
   // function PQescapeString(to:PAnsiChar; from:PAnsiChar; length:size_t):size_t; cdecl;
   function PQescapeString(c_to:PAnsiChar; from:PAnsiChar; length:size_t):size_t; cdecl;
   // function PQescapeBytea(from:Pbyte; from_length:size_t; to_length:Psize_t):Pbyte; cdecl;
   function PQescapeBytea(from:PByte; from_length:size_t; to_length:Psize_t):PByte; cdecl;

   { === in fe-print.c ===  }

   procedure PQprint(fout:PFILE;              { output stream }
                     res:PPGresult;
                     ps:PPQprintOpt); cdecl;  { option structure }


   { really old printing routines }

   procedure PQdisplayTuples(res:PPGresult;
                             fp:PFILE;                { where to send the output }
                             fillAlign:longint;       { pad the fields with spaces }
                             fieldSep:PAnsiChar;      { field separator }
                             printHeader:longint;     { display headers? }
                             quiet:longint); cdecl;

   procedure PQprintTuples(res:PPGresult;
                           fout:PFILE;               { output stream }
                           printAttName:longint;     { print attribute names }
                           terseOutput:longint;      { delimiter bars }
                           width:longint); cdecl;    { width of column, if 0, use variable width }

   { === in fe-lobj.c ===  }

   { Large-object access routines }

   function lo_open(conn:PPGconn; lobjId:Oid; mode:longint):longint; cdecl;
   function lo_close(conn:PPGconn; fd:longint):longint; cdecl;
   function lo_read(conn:PPGconn; fd:longint; buf:PAnsiChar; len:size_t):longint; cdecl;
   function lo_write(conn:PPGconn; fd:longint; buf:PAnsiChar; len:size_t):longint; cdecl;
   function lo_lseek(conn:PPGconn; fd:longint; offset:longint; whence:longint):longint; cdecl;

   // New in Postgres 9.3.2
   { /* New in Postgres 9.3.2: */
   extern pg_int64 lo_lseek64(PGconn *conn, int fd, pg_int64 offset, int whence);
   /* New in Postgres 9.3.2. */ }
   function lo_lseek64(conn:PPGconn; fd:longint; offset:pg_int64; whence:longint):pg_int64; cdecl;

   function lo_creat(conn:PPGconn; mode:longint):Oid; cdecl;
   function lo_create(conn:PPGconn; lobjId:Oid):Oid; cdecl;
   function lo_tell(conn:PPGconn; fd:longint):longint; cdecl;

   // New in Postgres 9.3.2
   { /* New in Postgres 9.3.2: */
   extern pg_int64 lo_tell64(PGconn *conn, int fd);
   /* New in Postgres 9.3.2. */ }
   function lo_tell64(conn:PPGconn; fd:longint):pg_int64; cdecl;

   function lo_truncate(conn:PPGconn; fd:longint; len:size_t):longint; cdecl;

   // New in Postgres 9.3.2
   { /* New in Postgres 9.3.2: */
   extern int	lo_truncate64(PGconn *conn, int fd, pg_int64 len);
   /* New in Postgres 9.3.2. */ }
   function lo_truncate64(conn:PPGconn; fd:longint; len:pg_int64):longint; cdecl;

   function lo_unlink(conn:PPGconn; lobjId:Oid):longint; cdecl;
   function lo_import(conn:PPGconn; filename:PAnsiChar):Oid; cdecl;
   function lo_import_with_oid(conn:PPGconn; filename:PAnsiChar; lobjId:Oid):Oid; cdecl;
   function lo_export(conn:PPGconn; lobjId:Oid; filename:PAnsiChar):longint; cdecl;

   { === in fe-misc.c === }

   // New in Postgres 9.3.2
   { Get the version of the libpq library in use }
   function PQlibVersion:longint; cdecl;

   { Determine length of multibyte encoded char at *s  }
   function PQmblen(s:PAnsiChar; encoding:longint):longint; cdecl;

   { Determine display length of multibyte encoded char at *s  }
   function PQdsplen(s:PAnsiChar; encoding:longint):longint; cdecl;

   { Get encoding id from environment variable PGCLIENTENCODING  }
   function PQenv2encoding:longint; cdecl;

   { === in fe-auth.c === }
   function PQencryptPassword(passwd:PAnsiChar; user:PAnsiChar):PAnsiChar; cdecl;

   { === in encnames.c === }
   function pg_char_to_encoding(name:PAnsiChar):longint; cdecl;
   function pg_encoding_to_char(encoding:longint):PAnsiChar; cdecl;
   function pg_valid_server_encoding_id(encoding:longint):longint; cdecl;

implementation

function PQconnectStart(conninfo:PAnsiChar):PPGconn; cdecl; external libpq;
function PQconnectStartParams(keywords:PPChars; values:PPChars; expand_dbname:longint):PPGconn; cdecl; external libpq;
function PQconnectPoll(conn:PPGconn):PostgresPollingStatusType; cdecl; external libpq;
function PQconnectdb(conninfo:PAnsiChar):PPGconn; cdecl; external libpq;
function PQconnectdbParams(keywords:PPChars; values:PPChars; expand_dbname:longint):PPGconn; cdecl; external libpq;
function PQsetdbLogin(pghost:PAnsiChar; pgport:PAnsiChar; pgoptions:PAnsiChar; pgtty:PAnsiChar; dbName:PAnsiChar;
           login:PAnsiChar; pwd:PAnsiChar):PPGconn; cdecl; external libpq;
procedure PQfinish(conn:PPGconn); cdecl; external libpq;
function PQconndefaults:PPQconninfoOption; cdecl; external libpq;
function PQconninfoParse(conninfo:PAnsiChar; errmsg:PPchar):PPQconninfoOption; cdecl; external libpq;

// New in Postgres 9.3.2
function PQconninfo(conn:PPGconn):PPQconninfoOption; cdecl; external libpq;

procedure PQconninfoFree(connOptions:PPQconninfoOption); cdecl; external libpq;
function PQresetStart(conn:PPGconn):longint; cdecl; external libpq;
function PQresetPoll(conn:PPGconn):PostgresPollingStatusType; cdecl; external libpq;
procedure PQreset(conn:PPGconn); cdecl; external libpq;
function PQgetCancel(conn:PPGconn):PPGcancel; cdecl; external libpq;
procedure PQfreeCancel(cancel:PPGcancel); cdecl; external libpq;
function PQcancel(cancel:PPGcancel; errbuf:PAnsiChar; errbufsize:longint):longint; cdecl; external libpq;
function PQrequestCancel(conn:PPGconn):longint; cdecl; external libpq;
function PQdb(conn:PPGconn):PAnsiChar; cdecl; external libpq;
function PQuser(conn:PPGconn):PAnsiChar; cdecl; external libpq;
function PQpass(conn:PPGconn):PAnsiChar; cdecl; external libpq;
function PQhost(conn:PPGconn):PAnsiChar; cdecl; external libpq;
function PQport(conn:PPGconn):PAnsiChar; cdecl; external libpq;
function PQtty(conn:PPGconn):PAnsiChar; cdecl; external libpq;
function PQoptions(conn:PPGconn):PAnsiChar; cdecl; external libpq;
function PQstatus(conn:PPGconn):ConnStatusType; cdecl; external libpq;
function PQtransactionStatus(conn:PPGconn):PGTransactionStatusType; cdecl; external libpq;
function PQparameterStatus(conn:PPGconn; paramName:PAnsiChar):PAnsiChar; cdecl; external libpq;
function PQprotocolVersion(conn:PPGconn):longint; cdecl; external libpq;
function PQserverVersion(conn:PPGconn):longint; cdecl; external libpq;
function PQerrorMessage(conn:PPGconn):PAnsiChar; cdecl; external libpq;
function PQsocket(conn:PPGconn):longint; cdecl; external libpq;
function PQbackendPID(conn:PPGconn):longint; cdecl; external libpq;
function PQconnectionNeedsPassword(conn:PPGconn):longint; cdecl; external libpq;
function PQconnectionUsedPassword(conn:PPGconn):longint; cdecl; external libpq;
function PQclientEncoding(conn:PPGconn):longint; cdecl; external libpq;
function PQsetClientEncoding(conn:PPGconn; encoding:PAnsiChar):longint; cdecl; external libpq;
function PQgetssl(conn:PPGconn):pointer; cdecl; external libpq;
procedure PQinitSSL(do_init:longint); cdecl; external libpq;
procedure PQinitOpenSSL(do_ssl:longint; do_crypto:longint); cdecl; external libpq;
function PQsetErrorVerbosity(conn:PPGconn; verbosity:PGVerbosity):PGVerbosity; cdecl; external libpq;
procedure PQtrace(conn:PPGconn; debug_port:PFILE); cdecl; external libpq;
procedure PQuntrace(conn:PPGconn); cdecl; external libpq;
function PQsetNoticeReceiver(conn:PPGconn; proc:PQnoticeReceiver; arg:pointer):PQnoticeReceiver; cdecl; external libpq;
function PQsetNoticeProcessor(conn:PPGconn; proc:PQnoticeProcessor; arg:pointer):PQnoticeProcessor; cdecl; external libpq;
function PQregisterThreadLock(newhandler:pgthreadlock_t):pgthreadlock_t; cdecl; external libpq;
function PQexec(conn:PPGconn; query:PAnsiChar):PPGresult; cdecl; external libpq;
function PQexecParams(conn:PPGconn; command:PAnsiChar; nParams:longint; paramTypes:POid; paramValues: PPChars;
           paramLengths: PIntegers; paramFormats: PIntegers; resultFormat:longint):PPGresult; cdecl; external libpq;
function PQprepare(conn:PPGconn; stmtName:PAnsiChar; query:PAnsiChar; nParams:longint; paramTypes:POid):PPGresult; cdecl; external libpq;
function PQexecPrepared(conn:PPGconn; stmtName:PAnsiChar; nParams:longint; paramValues: PPChars; paramLengths:PIntegers;
           paramFormats:PIntegers; resultFormat:longint):PPGresult; cdecl; external libpq;
function PQsendQuery(conn:PPGconn; query:PAnsiChar):longint; cdecl; external libpq;
function PQsendQueryParams(conn:PPGconn; command:PAnsiChar; nParams:longint; paramTypes:POid; paramValues: PPChars;
           paramLengths:Plongint; paramFormats:Plongint; resultFormat:longint):longint; cdecl; external libpq;
function PQsendPrepare(conn:PPGconn; stmtName:PAnsiChar; query:PAnsiChar; nParams:longint; paramTypes:POid):longint; cdecl; external libpq;
function PQsendQueryPrepared(conn:PPGconn; stmtName:PAnsiChar; nParams:longint; paramValues: PPChars; paramLengths:Plongint;
           paramFormats:Plongint; resultFormat:longint):longint; cdecl; external libpq;

// New in Postgres 9.3.2           
function PQsetSingleRowMode(conn:PPGconn):longint; cdecl; external libpq;

function PQgetResult(conn:PPGconn):PPGresult; cdecl; external libpq;
function PQisBusy(conn:PPGconn):longint; cdecl; external libpq;
function PQconsumeInput(conn:PPGconn):longint; cdecl; external libpq;
function PQnotifies(conn:PPGconn):PPGnotify; cdecl; external libpq;
function PQputCopyData(conn:PPGconn; buffer:PAnsiChar; nbytes:longint):longint; cdecl; external libpq;
function PQputCopyEnd(conn:PPGconn; errormsg:PAnsiChar):longint; cdecl; external libpq;
function PQgetCopyData(conn:PPGconn; buffer:PPchar; async:longint):longint; cdecl; external libpq;
function PQgetline(conn:PPGconn; _string:PAnsiChar; length:longint):longint; cdecl; external libpq;
function PQputline(conn:PPGconn; _string:PAnsiChar):longint; cdecl; external libpq;
function PQgetlineAsync(conn:PPGconn; buffer:PAnsiChar; bufsize:longint):longint; cdecl; external libpq;
function PQputnbytes(conn:PPGconn; buffer:PAnsiChar; nbytes:longint):longint; cdecl; external libpq;
function PQendcopy(conn:PPGconn):longint; cdecl; external libpq;
function PQsetnonblocking(conn:PPGconn; arg:longint):longint; cdecl; external libpq;
function PQisnonblocking(conn:PPGconn):longint; cdecl; external libpq;
function PQisthreadsafe:longint; cdecl; external libpq;
function PQping(conninfo:PAnsiChar):PGPing; cdecl; external libpq;
function PQpingParams(keywords:PPChars; values:PPChars; expand_dbname:longint):PGPing; cdecl; external libpq;
function PQflush(conn:PPGconn):longint; cdecl; external libpq;
function PQfn(conn:PPGconn; fnid:longint; result_buf:Plongint; result_len:Plongint; result_is_int:longint;
           args:PPQArgBlock; nargs:longint):PPGresult; cdecl; external libpq;
function PQresultStatus(res:PPGresult):ExecStatusType; cdecl; external libpq;
function PQresStatus(status:ExecStatusType):PAnsiChar; cdecl; external libpq;
function PQresultErrorMessage(res:PPGresult):PAnsiChar; cdecl; external libpq;
function PQresultErrorField(res:PPGresult; fieldcode:longint):PAnsiChar; cdecl; external libpq;
function PQntuples(res:PPGresult):longint; cdecl; external libpq;
function PQnfields(res:PPGresult):longint; cdecl; external libpq;
function PQbinaryTuples(res:PPGresult):longint; cdecl; external libpq;
function PQfname(res:PPGresult; field_num:longint):PAnsiChar; cdecl; external libpq;
function PQfnumber(res:PPGresult; field_name:PAnsiChar):longint; cdecl; external libpq;
function PQftable(res:PPGresult; field_num:longint):Oid; cdecl; external libpq;
function PQftablecol(res:PPGresult; field_num:longint):longint; cdecl; external libpq;
function PQfformat(res:PPGresult; field_num:longint):longint; cdecl; external libpq;
function PQftype(res:PPGresult; field_num:longint):Oid; cdecl; external libpq;
function PQfsize(res:PPGresult; field_num:longint):longint; cdecl; external libpq;
function PQfmod(res:PPGresult; field_num:longint):longint; cdecl; external libpq;
function PQcmdStatus(res:PPGresult):PAnsiChar; cdecl; external libpq;
function PQoidStatus(res:PPGresult):PAnsiChar; cdecl; external libpq;
function PQoidValue(res:PPGresult):Oid; cdecl; external libpq;
function PQcmdTuples(res:PPGresult):PAnsiChar; cdecl; external libpq;
function PQgetvalue(res:PPGresult; tup_num:longint; field_num:longint):PAnsiChar; cdecl; external libpq;
function PQgetlength(res:PPGresult; tup_num:longint; field_num:longint):longint; cdecl; external libpq;
function PQgetisnull(res:PPGresult; tup_num:longint; field_num:longint):longint; cdecl; external libpq;
function PQnparams(res:PPGresult):longint; cdecl; external libpq;
function PQparamtype(res:PPGresult; param_num:longint):Oid; cdecl; external libpq;
function PQdescribePrepared(conn:PPGconn; stmt:PAnsiChar):PPGresult; cdecl; external libpq;
function PQdescribePortal(conn:PPGconn; portal:PAnsiChar):PPGresult; cdecl; external libpq;
function PQsendDescribePrepared(conn:PPGconn; stmt:PAnsiChar):longint; cdecl; external libpq;
function PQsendDescribePortal(conn:PPGconn; portal:PAnsiChar):longint; cdecl; external libpq;
procedure PQclear(res:PPGresult); cdecl; external libpq;
procedure PQfreemem(ptr:pointer); cdecl; external libpq;
function PQmakeEmptyPGresult(conn:PPGconn; status:ExecStatusType):PPGresult; cdecl; external libpq;
function PQcopyResult(src:PPGresult; flags:longint):PPGresult; cdecl; external libpq;
function PQsetResultAttrs(res:PPGresult; numAttributes:longint; attDescs:PPGresAttDesc):longint; cdecl; external libpq;
function PQresultAlloc(res:PPGresult; nBytes:size_t):pointer; cdecl; external libpq;
function PQsetvalue(res:PPGresult; tup_num:longint; field_num:longint; value:PAnsiChar; len:longint):longint; cdecl; external libpq;
function PQescapeStringConn(conn:PPGconn; c_to:PAnsiChar; from:PAnsiChar; length:size_t; error:Plongint):size_t; cdecl; external libpq;

// New in Postgres 9.3.2
function PQescapeLiteral(conn:PPGconn; str:PAnsiChar; len:size_t):PAnsiChar; cdecl; external libpq;
function PQescapeIdentifier(conn:PPGconn; str:PAnsiChar; len:size_t):PAnsiChar; cdecl; external libpq;

function PQescapeByteaConn(conn:PPGconn; from:PByte; from_length:size_t; to_length:Psize_t):PByte; cdecl; external libpq;
function PQunescapeBytea(strtext:PByte; retbuflen:Psize_t):PByte; cdecl; external libpq;
function PQescapeString(c_to:PAnsiChar; from:PAnsiChar; length:size_t):size_t; cdecl; external libpq;
function PQescapeBytea(from:PByte; from_length:size_t; to_length:Psize_t):PByte; cdecl; external libpq;
procedure PQprint(fout:PFILE; res:PPGresult; ps:PPQprintOpt); cdecl; external libpq;
procedure PQdisplayTuples(res:PPGresult; fp:PFILE; fillAlign:longint; fieldSep:PAnsiChar; printHeader:longint;
            quiet:longint); cdecl; external libpq;
procedure PQprintTuples(res:PPGresult; fout:PFILE; printAttName:longint; terseOutput:longint; width:longint); cdecl; external libpq;
function lo_open(conn:PPGconn; lobjId:Oid; mode:longint):longint; cdecl; external libpq;
function lo_close(conn:PPGconn; fd:longint):longint; cdecl; external libpq;
function lo_read(conn:PPGconn; fd:longint; buf:PAnsiChar; len:size_t):longint; cdecl; external libpq;
function lo_write(conn:PPGconn; fd:longint; buf:PAnsiChar; len:size_t):longint; cdecl; external libpq;
function lo_lseek(conn:PPGconn; fd:longint; offset:longint; whence:longint):longint; cdecl; external libpq;
function lo_lseek64(conn:PPGconn; fd:longint; offset:pg_int64; whence:longint):pg_int64; cdecl; external libpq;
function lo_creat(conn:PPGconn; mode:longint):Oid; cdecl; external libpq;
function lo_create(conn:PPGconn; lobjId:Oid):Oid; cdecl; external libpq;
function lo_tell(conn:PPGconn; fd:longint):longint; cdecl; external libpq;
function lo_tell64(conn:PPGconn; fd:longint):pg_int64; cdecl; external libpq;
function lo_truncate(conn:PPGconn; fd:longint; len:size_t):longint; cdecl; external libpq;
function lo_truncate64(conn:PPGconn; fd:longint; len:pg_int64):longint; cdecl; external libpq;
function lo_unlink(conn:PPGconn; lobjId:Oid):longint; cdecl; external libpq;
function lo_import(conn:PPGconn; filename:PAnsiChar):Oid; cdecl; external libpq;
function lo_import_with_oid(conn:PPGconn; filename:PAnsiChar; lobjId:Oid):Oid; cdecl; external libpq;
function lo_export(conn:PPGconn; lobjId:Oid; filename:PAnsiChar):longint; cdecl; external libpq;

// New in Postgres 9.3.2
function PQlibVersion:longint; cdecl; external libpq;

function PQmblen(s:PAnsiChar; encoding:longint):longint; cdecl; external libpq;
function PQdsplen(s:PAnsiChar; encoding:longint):longint; cdecl; external libpq;
function PQenv2encoding:longint; cdecl; external libpq;
function PQencryptPassword(passwd:PAnsiChar; user:PAnsiChar):PAnsiChar; cdecl; external libpq;
function pg_char_to_encoding(name:PAnsiChar):longint; cdecl; external libpq;
function pg_encoding_to_char(encoding:longint):PAnsiChar; cdecl; external libpq;
function pg_valid_server_encoding_id(encoding:longint):longint; cdecl; external libpq;

// function PQsetdb(M_PGHOST,M_PGPORT,M_PGOPT,M_PGTTY,M_DBNAME : longint) : longint;
function PQsetdb(M_PGHOST,M_PGPORT,M_PGOPT,M_PGTTY,M_DBNAME : PAnsiChar) : PPGconn;
begin
  // PQsetdb:=PQsetdbLogin(M_PGHOST,M_PGPORT,M_PGOPT,M_PGTTY,M_DBNAME,NULL,NULL);
  result:=PQsetdbLogin(M_PGHOST,M_PGPORT,M_PGOPT,M_PGTTY,M_DBNAME,nil,nil);
end;

procedure PQfreeNotify(ptr : pointer);
begin
  PQfreemem(ptr);
end;

end.
