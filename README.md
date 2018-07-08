# Auto archiving with Big Objects

## A framework for automating archiving based on Big Objects

Implementation done on Task and Events with Activity_History__b big object. The core logic is concentrated on Activity_Archiving_Service.cls class, exposing methods for archiving Task and Events via @future calls or via AsyncSOQL. The automation is achieved by an Apex Scheduler or via a generic Invocable method throug Process Builder.

