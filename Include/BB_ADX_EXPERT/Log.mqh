//+---------------------------------------------------------------+
//| Gère les logs pour une appli                                  |
//+---------------------------------------------------------------+
#define K_CLog_Tag_Error         "ERR"
#define K_CLog_Tag_Warning       "WRN"
#define K_CLog_Tag_Info          "INF"
#define K_CLog_Tag_Debug         "DBG"
#define K_CLog_Separator        "|"
#define K_CLog_Level_Nothing     0
#define K_CLog_Level_Error       1
#define K_CLog_Level_Warning     2
#define K_CLog_Level_Info        3
#define K_CLog_Level_Debug       4

class CLog
{
private:
   bool     m_Error;
   int      m_Handle;
   datetime m_Date;
   uchar    m_Level;
   string   m_Folder;

   void RazData(void) { m_Error=false; m_Handle=INVALID_HANDLE; m_Date=0; m_Level=0; m_Folder=""; }
   void LevelNothing(void) { m_Level=K_CLog_Level_Nothing; }
   void LevelError(void) { m_Level=K_CLog_Level_Error; }
   void LevelWarning(void) { m_Level=K_CLog_Level_Warning; }
   void LevelInfo(void) { m_Level=K_CLog_Level_Info; }
   void LevelAll(void) { m_Level=K_CLog_Level_Debug; }
   
   void Writing(const string i_type, const string i_text, const string i_function);
   void Opening(void);
   void Closing(void);
   
public:   
   bool Config(const string i_folder);
   bool ConfigOk(void) { return(m_Folder != ""); }
   string GetFolder(void);
   void End(void) { this.Closing(); }   
   string InfosLogOperation(const string i_Strategy, const int i_detection, const string i_market);
   bool IsValidLevel(const int i_level) { return((i_level >= K_CLog_Level_Nothing) && (i_level <= K_CLog_Level_Debug)); }
   void SetLevel(const int i_level);
   string LevelToString(const int i_level);
   void ERROR(const string i_text, const string i_function = "");
   void WARNING(const string i_text, const string i_function = "");
   void INFO(const string i_text, const string i_function = "");
   void DEBUG(const string i_text, const string i_function = "");
   void ERROR_CODE(const int i_error = 0, const string i_function = "");
   void WARNING_CODE(const int i_error = 0, const string i_function = "");
};

bool CLog::Config(string i_folder)
{
   string l_folder = i_folder;
   CleanString(l_folder); 
   this.RazData();
   if (!FolderNameControl(l_folder, true)) { m_Folder = ""; return(false); }
   m_Folder = l_folder + IntegerToString(I_Robot_ID) + "\\";
   return(true);
}

string CLog::GetFolder(void)
{
   if (m_Folder == "") return("Répertoire des logs non initialisé !!!");
   return("Répertoire des logs : " + TerminalInfoString(TERMINAL_COMMONDATA_PATH) + "\\Files\\" + m_Folder);
}

string CLog::InfosLogOperation(const string i_Strategy, const int i_detection, const string i_market)
{
   MqlTick l_TickData;
   if (SymbolInfoTick(i_market, l_TickData))
      return(i_Strategy + "#" + IntegerToString(i_detection) + " [" + TimeToString(l_TickData.time, TIME_DATE|TIME_SECONDS) + "] ");
   return(i_Strategy + "#" + IntegerToString(i_detection) + " [???] ");
}

string CLog::LevelToString(const int i_level)
{
   switch (i_level)
   {
      case K_CLog_Level_Nothing : return("Aucun log");
      case K_CLog_Level_Error : return("Log d'erreur");
      case K_CLog_Level_Warning : return("Log d'erreur et warning");
      case K_CLog_Level_Info : return("Log opérationnels");
      case K_CLog_Level_Debug : return("Tous les log");
      default : return("???");
   }
}

void CLog::SetLevel(const int i_level)
{
   if (i_level != m_Level)
   {
      switch(i_level)
      {
         case K_CLog_Level_Nothing : LevelNothing(); break;
         case K_CLog_Level_Error : LevelError(); break;
         case K_CLog_Level_Warning : LevelWarning(); break;
         case K_CLog_Level_Info : LevelInfo(); break;
         case K_CLog_Level_Debug : LevelAll(); break;
      }
   }
}

void CLog::ERROR(const string i_text, const string i_function = "")
{
   if (m_Level >= K_CLog_Level_Error) this.Writing(K_CLog_Tag_Error, i_text, i_function);
}
void CLog::WARNING(const string i_text, const string i_function = "")
{
   if (m_Level >= K_CLog_Level_Warning) this.Writing(K_CLog_Tag_Warning, i_text, i_function);
}
void CLog::INFO(const string i_text, const string i_function = "")
{
   if (m_Level >= K_CLog_Level_Info) this.Writing(K_CLog_Tag_Info, i_text, i_function);
}
void CLog::DEBUG(const string i_text, const string i_function = "")
{
   if (m_Level >= K_CLog_Level_Debug) this.Writing(K_CLog_Tag_Debug, i_text, i_function);
}
void CLog::ERROR_CODE(const int i_error=0,const string i_function="")
{
   this.ERROR( "Erreur " + ErrorToString(i_error), i_function);
}
void CLog::WARNING_CODE(const int i_error=0,const string i_function="")
{
   this.WARNING( "Erreur " + ErrorToString(i_error), i_function);
}

void CLog::Writing(const string i_type, const string i_text, const string i_function)
{
   MqlDateTime l_StructureDateLocal, l_StructureDate;
   string l_text;  
   if (m_Handle != INVALID_HANDLE)
   {
      TimeToStruct(TimeLocal(), l_StructureDateLocal);
      TimeToStruct(m_Date, l_StructureDate);
      if ((l_StructureDateLocal.day != l_StructureDate.day) || (l_StructureDateLocal.mon != l_StructureDate.mon))
         this.Closing(); 
   }
   this.Opening();
   if (m_Handle > INVALID_HANDLE)
   {
      l_text = i_type + K_CLog_Separator + TimeToString(TimeLocal(), TIME_SECONDS) + K_CLog_Separator + i_function + K_CLog_Separator + i_text;
      FileWrite(m_Handle, l_text);
      FileFlush(m_Handle);
   }
}

void CLog::Closing(void)
{
   if (m_Handle != INVALID_HANDLE)
   {
      string l_text = K_CLog_Tag_Info + K_CLog_Separator + "23:59:59" + K_CLog_Separator + "BILAN JOURNALIER" + K_CLog_Separator + DoubleToString(0.0, 3) + "%";
      FileWrite(m_Handle, l_text);
      FileClose(m_Handle);
   }
   m_Handle = INVALID_HANDLE;
   m_Date = 0;
}

void CLog::Opening(void)
{
   if (m_Handle == INVALID_HANDLE)
   {
      m_Date = TimeLocal();
      string l_Filename = m_Folder + TimeToString(m_Date, TIME_DATE) + Symbol() + ".log";
      ResetLastError();
      m_Handle = FileOpen(l_Filename, FILE_COMMON|FILE_READ|FILE_WRITE|FILE_TXT|FILE_ANSI|FILE_SHARE_READ);
      if (m_Handle == INVALID_HANDLE) m_Error = true;
      else { FileSeek(m_Handle, 0, SEEK_END); m_Error = false; }
   }
}
