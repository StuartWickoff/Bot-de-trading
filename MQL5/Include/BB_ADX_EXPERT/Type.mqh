//+------------------------------------------------------------------+
//| Conteneur de toutes les fonctions générales, tous les types      |
//| énumérés communs aux logiciels et toutes les structures          |
//| générales pouvant être utilisées                                 |
//+------------------------------------------------------------------+

//////////////////////////////////////////////////////////
//                                                      //
//                   E N U M E R E S                    //
//                                                      //
//////////////////////////////////////////////////////////

enum ENUM_TREND
{
   eT_Unknown = 0,
   eT_Bear,
   eT_Bull,
};

enum ENUM_IMPACT_LEVEL
{
   eI_Nothing = 0,
   eI_Minor,
   eI_Medium,
   eI_Major,
};

enum ENUM_LOG_LEVEL
{
   eL_Nothing = 0,
   eL_Error,
   eL_Warning,
   eL_Info,
   eL_All,
};

enum ENUM_VISU
{
   eV_Nothing = 0,
   eV_Small,
   eV_Medium,
   eV_Large,
};

//////////////////////////////////////////////////////////
//                                                      //
//                S T R U C T U R E                     //
//                                                      //
//////////////////////////////////////////////////////////

struct STRUCT_DATETIME_VAL
{
   bool     valid;
   datetime value;
};

struct STRUCT_INT_VAL
{
   bool     valid;
   int      value;
};

struct STRUCT_DOUBLE_VAL
{
   bool     valid;
   double   value;
};

struct STRUCT_LOG_VAL
{
   bool     valid;
   int      level;
};

struct STRUCT_ALERT_VAL
{
   bool     valid;
   bool     text;
   bool     sound;
   bool     notif;
};

struct STRUCT_VISU_VAL
{
   bool     valid;
   int      height;
};

struct STRUCT_NEWS
{
   datetime            date;
   ENUM_IMPACT_LEVEL   impact;
   int                 security;
};

struct STRUCT_STRATEGY
{
   int           No_detection;
   int           No_ticket;
   ENUM_TREND    Trend;
   double        Size;
   double        Entry;
   double        StopLoss;
   double        TakeProfit;
};
