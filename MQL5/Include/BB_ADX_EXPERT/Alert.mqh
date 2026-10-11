//+-----------------------------------------------------------------+
//| Gère l'envoi des alertes                                        |
//|                                                                 |
//| - Configure le type d'alerte (son, message, notification)       |
//| - Envoi une alerte en fonction des types d'alerte sélectionnées |
//+-----------------------------------------------------------------+
//| Dépendances :                                                   |
//| - Fichier Tools.mqh         : Fonctions de mise en forme        |
//| - Fichier Type.mqh          : Énuméré des niveaux               |
//| - Fichier Log.mqh           : Gestion des logs                  |
//+-----------------------------------------------------------------+

//////////////////////////////////////////////////////////
//                                                      //
//                  C L A S S                           //
//                                                      //
//////////////////////////////////////////////////////////
class CAlert
{
//================================
//---  PRIVATE
//================================
private:
   string   m_AppName;      // Nom de l'application
   string   m_Sound;        // Fichier son à utiliser
   bool     m_TextAlert;    // Alerte texte écran
   bool     m_SoundAlert;   // Alerte sonore
   bool     m_NotifAlert;   // Alerte notification

//================================
//---  PUBLIC
//================================
public:             
   void Config(const string i_appName, const string i_soundFile);
   void AlertType(const bool i_text, const bool i_sound, const bool i_notification);
   bool SEND(const string i_text = "", const bool i_WithLog = true);
};

//////////////////////////////////////////////////////////
//                                                      //
//              F U N C T I O N S                       //
//                                                      //
//////////////////////////////////////////////////////////

void CAlert::Config(const string i_appName, const string i_soundFile)
{
   m_AppName    = i_appName;
   m_Sound      = i_soundFile;
   m_TextAlert  = false;
   m_SoundAlert = false;
   m_NotifAlert = false;
   SoundNameControl(m_Sound, __FUNCTION__);
}

void CAlert::AlertType(const bool i_text, const bool i_sound, const bool i_notification)
{
   m_TextAlert   = i_text;
   m_SoundAlert  = i_sound;
   m_NotifAlert  = i_notification;
}

bool CAlert::SEND(const string i_text="", const bool i_WithLog=true)
{
   string l_FormatedMesssage;
   bool   l_WithoutError;
   
   if (m_AppName == "")
   {
      if (i_WithLog) LOG.WARNING("Objet ALERTE pas initialisé !!!", __FUNCTION__);
      return(false);
   }
   
   l_FormatedMesssage = m_AppName + " - " + i_text;
   l_WithoutError     = true;
   
   if (m_TextAlert) Alert(l_FormatedMesssage);
   
   if (m_NotifAlert)
   {
      ResetLastError();
      if (!SendNotification(l_FormatedMesssage))
      {
         if (i_WithLog) LOG.WARNING_CODE(GetLastError(), __FUNCTION__);
         l_WithoutError = false;
      }
   }
   
   if (m_SoundAlert && (m_Sound != ""))
   {
      if (!PlaySound(m_Sound))
      {
         if (i_WithLog) LOG.WARNING("Erreur PlaySound avec '" + m_Sound + "' !!!", __FUNCTION__);
         l_WithoutError = false;
      }
   }
   
   return(l_WithoutError);
}
